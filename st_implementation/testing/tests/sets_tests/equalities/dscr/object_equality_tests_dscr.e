note
	description: "Test suite for {STS_OBJECT_EQUALITY [detachable separate CHARACTER_REF]]}"
	author: "Rosivaldo F Alves"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	OBJECT_EQUALITY_TESTS_DSCR

inherit
	OBJECT_EQUALITY_TESTS [detachable separate CHARACTER_REF, STS_OBJECT_EQUALITY [detachable separate CHARACTER_REF]]
		rename
			some_object_a as some_separate_character_ref,
			some_immediate_equality_a as some_object_equality_dscr,
			some_set_a as some_set_of_objects_dscr
		redefine
			properties,
			test_all,
			test_holds,
			test_holds_successively
		end

	TESTS_DSCR
		rename
			element_to_be_tested as equality_to_be_tested
		undefine
			on_prepare,
			equality_to_be_tested
		redefine
			properties,
			test_all
		end

feature -- Access

	properties: STP_OBJECT_EQUALITY_PROPERTIES [detachable separate CHARACTER_REF, STS_OBJECT_EQUALITY [detachable separate CHARACTER_REF]]
			-- <Precursor>

feature -- Test routines (All)

	test_all
			-- Test every routine of {STS_OBJECT_EQUALITY}.
		note
			testing: "covers/{STS_OBJECT_EQUALITY}"
		do
			Precursor {OBJECT_EQUALITY_TESTS}
			test_holds
			test_holds_successively
		end

feature -- Test routines (Relationship)

	test_holds
			-- <Precursor>
		note
			testing: "covers/{STS_OBJECT_EQUALITY}.holds"
		do
			Precursor {OBJECT_EQUALITY_TESTS}
		end

	test_holds_successively
			-- <Precursor>
		note
			testing: "covers/{STS_INSTANCE_FREE_EQUALITY}.holds_successively"
			testing: "covers/{STS_OBJECT_EQUALITY}.holds_successively"
		do
			Precursor {OBJECT_EQUALITY_TESTS}
		end

note
	copyright: "Copyright (c) 2012-2023, Rosivaldo F Alves"
	license: "[
		Eiffel Forum License v2
		(see http://www.eiffel.com/licensing/forum.txt)
		]"
	source: ""
end
