extends RefCounted
@warning_ignore_start("integer_division")
## Authoritative race state. Integer math only; no scene, clock, input or physics APIs.
## Distances are millimetres. Division deliberately truncates towards zero.

const RULES_VERSION := 1
const TICKS_PER_SECOND := 60
const TURN := 65536
const TRIG_SCALE := 1000000
const SEGMENTS := 320
const HALF_WIDTH := 7000
const HOVER_HEIGHT := 1500
const WORLD_LIMIT := 1000000
const MAX_SPEED := 38000 * TICKS_PER_SECOND
const ACCELERATION := 22000
const BRAKING := 32000
const FRICTION := 9000
const TURN_RATE := 22947 # Approximately 2.2 radians per second, in turns/65536.
const STEER_DENOMINATOR := 127 * TICKS_PER_SECOND * 15000 * TICKS_PER_SECOND
const MOVE_DENOMINATOR := TICKS_PER_SECOND * TICKS_PER_SECOND * TRIG_SCALE
const SNAPSHOT_SIZE := 13

# Arrays hold int64 coordinates; Vector3/Vector3i must not enter simulation math.
var _centers: Array[PackedInt64Array] = []
var _normals: Array[PackedInt64Array] = []
var tick := 0
var x := 0
var y := 0
var z := 0
var speed := 0 # mm/s multiplied by tick rate, retaining acceleration fractions.
var heading := TURN / 4
var on_track := true
var random_state := 84321
var _turn_remainder := 0
var _x_remainder := 0
var _z_remainder := 0

func _init() -> void:
    for i in range(SEGMENTS):
        var angle := i * TURN / SEGMENTS
        var cosine := sine(angle + TURN / 4)
        _centers.append(PackedInt64Array([
            110000 * sine(angle) / TRIG_SCALE,
            3000 * (TRIG_SCALE + cosine) * (TRIG_SCALE + cosine) / (TRIG_SCALE * TRIG_SCALE),
            72000 * sine(2 * angle) / TRIG_SCALE,
        ]))
    for i in range(SEGMENTS):
        var before := _centers[(i + SEGMENTS - 1) % SEGMENTS]
        var after := _centers[(i + 1) % SEGMENTS]
        var dx := after[0] - before[0]
        var dz := after[2] - before[2]
        var length := integer_sqrt(dx * dx + dz * dz)
        _normals.append(PackedInt64Array([dz * TRIG_SCALE / length, -dx * TRIG_SCALE / length]))
    var spawn := _centers[SEGMENTS / 8]
    x = spawn[0]
    y = spawn[1] + HOVER_HEIGHT
    z = spawn[2]

static func sine(angle: int) -> int:
    # Bhaskara's rational approximation; fixed constants and int64 intermediates.
    # Maximum intermediate is below 2^55. No platform-dependent libm calls.
    angle = posmod(angle, TURN)
    var sign_value := 1
    if angle > TURN / 2:
        angle -= TURN / 2
        sign_value = -1
    var product := angle * (TURN / 2 - angle)
    return sign_value * 16 * product * TRIG_SCALE / (5 * (TURN / 2) * (TURN / 2) - 4 * product)

static func integer_sqrt(value: int) -> int:
    if value <= 0:
        return 0
    var estimate := value
    var next := (estimate + 1) / 2
    while next < estimate:
        estimate = next
        next = (estimate + value / estimate) / 2
    return estimate

func track_point(index: int, offset: int = 0) -> PackedInt64Array:
    index = posmod(index, SEGMENTS)
    var center := _centers[index]
    var normal := _normals[index]
    return PackedInt64Array([
        center[0] + normal[0] * offset / TRIG_SCALE,
        center[1],
        center[2] + normal[1] * offset / TRIG_SCALE,
    ])

func nearest_track_point(px: int, py: int, pz: int) -> PackedInt64Array:
    var nearest := _centers[0]
    var best_distance := 9223372036854775807
    for i in range(SEGMENTS):
        var start := _centers[i]
        var finish := _centers[(i + 1) % SEGMENTS]
        var dx := finish[0] - start[0]
        var dy := finish[1] - start[1]
        var dz := finish[2] - start[2]
        var length_squared := dx * dx + dy * dy + dz * dz
        var dot := (px - start[0]) * dx + (py - start[1]) * dy + (pz - start[2]) * dz
        var weight := clampi(dot * TRIG_SCALE / length_squared, 0, TRIG_SCALE)
        var candidate := PackedInt64Array([
            start[0] + dx * weight / TRIG_SCALE,
            start[1] + dy * weight / TRIG_SCALE,
            start[2] + dz * weight / TRIG_SCALE,
        ])
        var distance := (px - candidate[0]) * (px - candidate[0]) + (py - candidate[1]) * (py - candidate[1]) + (pz - candidate[2]) * (pz - candidate[2])
        # Strict comparison resolves equal distances in ascending segment order.
        if distance < best_distance:
            best_distance = distance
            nearest = candidate
    return nearest

func step(accelerate: bool, brake: bool, steering: int) -> void:
    _update_speed(accelerate, brake)
    _update_heading(clampi(steering, -127, 127))
    _move_forward()
    _follow_track_elevation()
    tick += 1

func _update_speed(accelerate: bool, brake: bool) -> void:
    if brake:
        speed = maxi(0, speed - BRAKING)
    elif accelerate:
        speed = mini(MAX_SPEED, speed + ACCELERATION)
    else:
        speed = maxi(0, speed - FRICTION)

func _update_heading(steering: int) -> void:
    var numerator := -steering * TURN_RATE * mini(speed, 15000 * TICKS_PER_SECOND) + _turn_remainder
    heading = posmod(heading + numerator / STEER_DENOMINATOR, TURN)
    _turn_remainder = numerator % STEER_DENOMINATOR

func _move_forward() -> void:
    var move_x := sine(heading) * speed + _x_remainder
    var move_z := sine(heading + TURN / 4) * speed + _z_remainder
    x = clampi(x + move_x / MOVE_DENOMINATOR, -WORLD_LIMIT, WORLD_LIMIT)
    z = clampi(z + move_z / MOVE_DENOMINATOR, -WORLD_LIMIT, WORLD_LIMIT)
    _x_remainder = move_x % MOVE_DENOMINATOR
    _z_remainder = move_z % MOVE_DENOMINATOR

func _follow_track_elevation() -> void:
    var nearest := nearest_track_point(x, y - HOVER_HEIGHT, z)
    on_track = _within_track_width(nearest)
    var target_y := (nearest[1] if on_track else 0) + HOVER_HEIGHT
    _approach_elevation(target_y)

func _within_track_width(nearest: PackedInt64Array) -> bool:
    var dx := x - nearest[0]
    var dz := z - nearest[2]
    return dx * dx + dz * dz <= HALF_WIDTH * HALF_WIDTH

func _approach_elevation(target_y: int) -> void:
    var difference := target_y - y
    var rise := difference / 8
    if rise == 0 and difference != 0:
        rise = 1 if difference > 0 else -1
    y += rise

func next_random() -> int:
    # Gameplay RNG, separate from cosmetic Godot RNG. State is saved for rollback.
    random_state = (1103515245 * random_state + 12345) & 0x7fffffff
    return random_state

func snapshot() -> PackedInt64Array:
    return PackedInt64Array([RULES_VERSION, tick, x, y, z, speed, heading,
        int(on_track), random_state, _turn_remainder, _x_remainder, _z_remainder, TICKS_PER_SECOND])

func restore(state: PackedInt64Array) -> bool:
    # Validate before mutation. Bounds also guarantee safe int64 intermediates.
    if state.size() != SNAPSHOT_SIZE:
        return false
    if state[0] != RULES_VERSION or state[12] != TICKS_PER_SECOND or state[1] < 0:
        return false
    if state[2] < -WORLD_LIMIT or state[2] > WORLD_LIMIT or state[3] < 0 or state[3] > 13500 or state[4] < -WORLD_LIMIT or state[4] > WORLD_LIMIT:
        return false
    if state[5] < 0 or state[5] > MAX_SPEED or state[6] < 0 or state[6] >= TURN:
        return false
    if state[7] not in [0, 1] or state[8] < 0 or state[8] > 0x7fffffff:
        return false
    if state[9] <= -STEER_DENOMINATOR or state[9] >= STEER_DENOMINATOR:
        return false
    if state[10] <= -MOVE_DENOMINATOR or state[10] >= MOVE_DENOMINATOR or state[11] <= -MOVE_DENOMINATOR or state[11] >= MOVE_DENOMINATOR:
        return false
    tick = state[1]
    x = state[2]
    y = state[3]
    z = state[4]
    speed = state[5]
    heading = state[6]
    on_track = state[7] == 1
    random_state = state[8]
    _turn_remainder = state[9]
    _x_remainder = state[10]
    _z_remainder = state[11]
    return true

func canonical_state() -> String:
    # Decimal int64 text avoids endian, float and Variant serialization differences.
    var fields := PackedStringArray()
    for value in snapshot():
        fields.append(str(value))
    return ",".join(fields)
