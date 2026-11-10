extends SceneTree
## Run: Godot --headless --path game --script res://tests/test_determinism.gd

const Simulation = preload("res://simulation/race_simulation.gd")
const REPLAY_TICKS := 3600
const GOLDEN_PATH := "res://tests/replay.sha256"
var failures := 0

func _initialize() -> void:
    _test_math()
    _test_handling()
    _test_track()
    _test_snapshots()
    _verify_replay()
    _report_results()

func _verify_replay() -> void:
    var first := _replay_digest()
    _check(first == _replay_digest(), "Independent replay runs must match at every tick")
    _verify_golden_replay(first)
    print("Replay SHA-256: ", first)

func _verify_golden_replay(actual: String) -> void:
    if not FileAccess.file_exists(GOLDEN_PATH):
        _check(false, "Missing golden replay fixture. Observed digest: " + actual)
        return
    var expected := FileAccess.get_file_as_string(GOLDEN_PATH).strip_edges()
    _check(actual == expected, "Replay differs from the cross-platform golden: " + actual)

func _report_results() -> void:
    print("Deterministic simulation checks: ", "PASS" if failures == 0 else "FAIL (%d)" % failures)
    quit(0 if failures == 0 else 1)

func _check(condition: bool, message: String) -> void:
    if not condition:
        failures += 1
        push_error(message)

func _test_math() -> void:
    _test_sine_landmarks()
    _test_sine_symmetry()
    _test_integer_square_roots()

func _test_sine_landmarks() -> void:
    _check(Simulation.sine(0) == 0, "sin(0)")
    _check(Simulation.sine(16384) == 1000000, "sin(quarter turn)")
    _check(Simulation.sine(32768) == 0, "sin(half turn)")
    _check(Simulation.sine(49152) == -1000000, "sin(three-quarter turn)")

func _test_sine_symmetry() -> void:
    for angle in range(0, 65536, 193):
        _check(Simulation.sine(angle) == -Simulation.sine(-angle), "Sine odd symmetry")
        _check(Simulation.sine(angle) == Simulation.sine(angle + 65536), "Sine period")

func _test_integer_square_roots() -> void:
    for value in [0, 1, 2, 3, 4, 49, 50, 1000000000000]:
        var root := Simulation.integer_sqrt(value)
        _check(root * root <= value and (root + 1) * (root + 1) > value, "Integer square root floor")

func _test_handling() -> void:
    var race := Simulation.new()
    var start_x: int = race.x
    var start_z: int = race.z
    for i in range(60):
        race.step(true, false, 0)
    _check(race.speed == 22000 * 60, "Exactly 22 m/s after one second of acceleration")
    _check(race.x > start_x and race.z == start_z, "Spawn heads along +X")
    for i in range(60):
        race.step(true, false, 0)
    _check(race.speed == Simulation.MAX_SPEED, "Speed cap")
    for i in range(120):
        race.step(true, true, 0)
    _check(race.speed == 0, "Brake takes priority and stops without reversing")
    var left := Simulation.new()
    var right := Simulation.new()
    for race_state in [left, right]:
        var state: PackedInt64Array = race_state.snapshot()
        state[2] = 0
        state[3] = 1500
        state[4] = 0
        state[6] = 0
        _check(race_state.restore(state), "Restore symmetry starting state")
    for i in range(600):
        left.step(true, false, -127)
        right.step(true, false, 127)
        _check(left.x == -right.x and left.z == right.z, "Left/right travel symmetry")
        _check(left.heading == posmod(-right.heading, Simulation.TURN), "Left/right heading symmetry")
    _check(right.tick == 600, "One step equals one tick")
    var boundary := race.snapshot()
    boundary[2] = Simulation.WORLD_LIMIT
    boundary[6] = Simulation.TURN / 4
    boundary[5] = Simulation.MAX_SPEED
    _check(race.restore(boundary), "Restore at world boundary")
    race.step(true, false, 0)
    _check(race.x == Simulation.WORLD_LIMIT, "World boundary clamps safely")

func _test_track() -> void:
    var race := Simulation.new()
    _check(race.track_point(0) == race.track_point(Simulation.SEGMENTS), "Closed track")
    _test_crossover_projection(race)
    _test_crossover_elevation(race)
    _test_off_track_classification(race)

func _test_crossover_projection(race: RefCounted) -> void:
    var upper: PackedInt64Array = race.nearest_track_point(0, 12000, 0)
    var lower: PackedInt64Array = race.nearest_track_point(0, 0, 0)
    _check(upper == PackedInt64Array([0, 12000, 0]), "Upper crossover branch")
    _check(lower == PackedInt64Array([0, 0, 0]), "Lower crossover branch")

func _test_crossover_elevation(race: RefCounted) -> void:
    var state: PackedInt64Array = race.snapshot()
    state[2] = 0
    state[3] = 13500
    state[4] = 0
    _check(race.restore(state), "Restore upper crossing")
    race.step(false, false, 0)
    _check(race.on_track and race.y == 13500, "Upper crossing stays on bridge")
    state[3] = 1500
    _check(race.restore(state), "Restore lower crossing")
    race.step(false, false, 0)
    _check(race.on_track and race.y == 1500, "Lower crossing stays under bridge")

func _test_off_track_classification(race: RefCounted) -> void:
    var state: PackedInt64Array = race.snapshot()
    state[2] = 500000
    state[4] = 500000
    _check(race.restore(state), "Restore off track")
    race.step(false, false, 0)
    _check(not race.on_track, "Off-track classification")

func _test_snapshots() -> void:
    var race := Simulation.new()
    for i in range(731):
        _advance(race, i)
    var saved: PackedInt64Array = race.snapshot()
    for i in range(731, 1500):
        _advance(race, i)
    var expected: String = race.canonical_state()
    _check(race.restore(saved), "Restore complete simulation snapshot")
    for i in range(731, 1500):
        _advance(race, i)
    _check(race.canonical_state() == expected, "Rollback preserves sub-millimetre remainders and RNG")
    var invalid := saved.duplicate()
    invalid[0] += 1
    _check(not race.restore(invalid), "Reject incompatible rules version")
    invalid = saved.duplicate()
    invalid[2] = Simulation.WORLD_LIMIT + 1
    _check(not race.restore(invalid), "Reject unsafe coordinate range")
    _check(not race.restore(PackedInt64Array()), "Reject truncated snapshot")
    _check(race.canonical_state() == expected, "Invalid restore is atomic")

func _advance(race: RefCounted, index: int) -> void:
    var phase := index % 960
    var steering := 0 if phase < 240 else (74 if phase < 480 else (-127 if phase < 720 else 31))
    race.step(index % 420 < 330, index % 420 >= 360, steering)
    if index % 97 == 0:
        race.next_random()

func _replay_digest() -> String:
    var race := Simulation.new()
    var hash_context := HashingContext.new()
    hash_context.start(HashingContext.HASH_SHA256)
    _hash_track_vertices(race, hash_context)
    _hash_replay_states(race, hash_context)
    return hash_context.finish().hex_encode()

func _hash_track_vertices(race: RefCounted, hash_context: HashingContext) -> void:
    for index in range(Simulation.SEGMENTS):
        for offset in [-Simulation.HALF_WIDTH, 0, Simulation.HALF_WIDTH]:
            var point: PackedInt64Array = race.track_point(index, offset)
            hash_context.update(("%d,%d,%d;" % [point[0], point[1], point[2]]).to_utf8_buffer())

func _hash_replay_states(race: RefCounted, hash_context: HashingContext) -> void:
    _hash_state(race, hash_context)
    for index in range(REPLAY_TICKS):
        _advance(race, index)
        _hash_state(race, hash_context)

func _hash_state(race: RefCounted, hash_context: HashingContext) -> void:
    hash_context.update((race.canonical_state() + "\n").to_utf8_buffer())
