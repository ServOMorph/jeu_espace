extends GdUnitTestSuite

func test_framework_operationnel() -> void:
	assert_int(1 + 1).is_equal(2)
