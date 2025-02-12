class_name GdUnitTestCoverage
extends RefCounted

# Minimum overall coverage target
static var DEFAULT_COVERAGE_TARGET := 0.0

# Minimum per file coverage target
static var DEFAULT_FILE_TARGET := 0.0

# Default paths to exclude from coverage instrumentation
static var DEFAULT_EXCLUDE_PATHS = [
	"res://addons/*",
	# NOTE: Godot may crash if you try to instrument the script that's calling instrument_scripts()
	"res://tests/*",
]

static var instance

static func setup_test_coverage(tree : SceneTree, exclude_paths = DEFAULT_EXCLUDE_PATHS):
	assert(instance == null, "Do not overwrite class singleton instance by calling setup twice")
	assert(tree != null, "The scene tree for initializing test coverage class may not be null")
	instance = TestCoverage.new(tree, exclude_paths)

static func set_report_file(filename := OS.get_environment("COVERAGE_FILE")):
	assert(instance != null, "Before using this method ensure you setup coverage with setup_test_coverage")
	instance.save_coverage_file(filename)

static func add_checked_directory(source_dir : String):
	assert(instance != null, "Before using this method ensure you setup coverage with setup_test_coverage")
	instance.instrument_scripts(source_dir)

static func teardown_test_coverage(verbosity := TestCoverage.Verbosity.FILENAMES) -> bool:
	assert(instance != null, "Before using this method ensure you setup coverage with setup_test_coverage")
	instance._finalize(verbosity)
	return  instance.coverage_passing()
