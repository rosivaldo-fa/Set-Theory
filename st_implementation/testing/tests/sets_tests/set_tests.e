﻿note
	description: "Test suite for {SET}"
	author: "Rosivaldo F Alves"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SET_TESTS [A, EQ -> STS_EQUALITY [A] create default_create end]

inherit
	UNARY_TESTS [A, EQ]
		rename
			test_is_in as element_test_is_in,
			element_to_be_tested as set_to_be_tested
		redefine
			properties,
			set_to_be_tested
		end

feature -- Access

	properties: SET_PROPERTIES [A, EQ]
			-- Object that checks the set-theory properties of {SET}

feature -- Test routines (Primitive)

	test_is_empty
			-- Test {SET}.is_empty.
		note
			testing: "covers/{SET}.is_empty"
		local
			s: like set_to_be_tested
		do
			inspect
				next_random_item \\ 3
			when 0 then
				s := o
			when 1 then
				s := set_to_be_tested.o
			when 2 then
				s := set_to_be_tested
				s := s.o-- ∖ same_set_a (s)
			end
			assert ("s.is_empty", s.is_empty)
			assert ("s.is_empty ok", properties.is_empty_ok (s))

			s := set_to_be_tested & some_object_a
			assert ("not s.is_empty", not s.is_empty)
			assert ("not s.is_empty ok", properties.is_empty_ok (s))

			s := set_to_be_tested
			assert ("is_empty", s.is_empty ⇒ True)
			assert ("is_empty_ok", properties.is_empty_ok (s))
		end

	test_any
			-- Test {SET}.any.
		note
			testing: "covers/{SET}.any"
		local
			s: like set_to_be_tested
		do
			s := set_to_be_tested & some_object_a
				check
					is_not_empty: not s.is_empty -- s ≍ {a, ...}
				end
			assert ("s.any", attached s.any ⇒ True)
			assert ("s.any ok", properties.any_ok (s))

			s := set_to_be_tested
			assert ("any", not s.is_empty ⇒ attached s.any ⇒ True)
			assert ("any_ok", properties.any_ok (s))
		end

	test_others
			-- Test {SET}.others.
		note
			testing: "covers/{SET}.others"
		local
			s: like set_to_be_tested
			a, b, c: like some_object_a
		do
			s := o
--			assert ("∅", s.others ≍ o)
			assert ("∅ ok", properties.others_ok (s))

			s := s & some_object_a
				check
					is_not_empty: not s.is_empty -- s = {a}
				end
			a := same_object_a (s.any)
--			assert ("{a}", s.others ≍ o)
			assert ("{a} ok", properties.others_ok (s))

			s := s & some_other_object_a (s)
				check
					is_not_empty_2: not s.others.is_empty -- s = {a,b}
				end
			b := same_set_a (s.others).any
--			assert ("{a,b}", s.others ≍ (o & b))
			assert ("{a,b} ok", properties.others_ok (s))

			s := s & some_other_object_a (s)
				check
					is_not_empty_3: not s.others.is_empty -- # s = 3
				end
			b := same_set_a (s.others).any
				check
					is_not_empty_4: not (s.others / b).is_empty -- # s = 3
				end
			c := same_set_a (s.others / b).any
--			assert ("{a,b,c}", s.others ≍ (s.o & b & c))
			assert ("{a,b,c} ok", properties.others_ok (s))

			s := set_to_be_tested
			assert ("others", attached s.others)
			assert ("others_ok", properties.others_ok (s))
		end

	test_eq
			-- Test {SET}.eq.
		note
			testing: "covers/{SET}.eq"
		do
			assert ("eq", attached set_to_be_tested.eq)
			assert ("class: eq", attached {like set_to_be_tested}.eq)
		end

feature -- Test routines (Membership)

	test_is_in
			-- Test {STS_SET}.is_in.
			-- Test {SET}.is_in.
		note
			testing: "covers/{STS_SET}.is_in"
			testing: "covers/{SET}.is_in"
		local
			s: like set_to_be_tested
			ss: like some_set_sa
		do
			s := set_to_be_tested
			ss := some_set_references_a & s
			assert ("s ∈ ss", s ∈ ss)
			assert ("s ∈ ss ok", properties.is_in_ok (s, ss))

			ss := some_set_references_a / s
			assert ("not (s ∈ ss)", not (s ∈ ss))
			assert ("not (s ∈ ss) ok", properties.is_in_ok (s, ss))

			ss := some_set_standard_objects_a & s.standard_twin
			assert ("s.standard_twin ∈ ss", s ∈ ss)
			assert ("s.standard_twin ∈ ss ok", properties.is_in_ok (s, ss))

			ss := some_set_standard_objects_a / s.standard_twin
			assert ("not (s.standard_twin ∈ ss)", not (s ∈ ss))
			assert ("not (s.standard_twin ∈ ss) ok", properties.is_in_ok (s, ss))

			ss := some_set_objects_a & s.twin
			assert ("s.twin ∈ ss", s ∈ ss)
			assert ("s.twin ∈ ss ok", properties.is_in_ok (s, ss))

			ss := some_set_objects_a / s.twin
			assert ("not (s.twin ∈ ss)", not (s ∈ ss))
			assert ("not (s.twin ∈ ss) ok", properties.is_in_ok (s, ss))

			ss := some_set_deep_objects_a & s.deep_twin
			assert ("s.deep_twin ∈ ss", s ∈ ss)
			assert ("s.deep_twin ∈ ss ok", properties.is_in_ok (s, ss))

			ss := some_set_deep_objects_a / s.deep_twin
			assert ("not (s.deep_twin ∈ ss)", not (s ∈ ss))
			assert ("not (s.deep_twin ∈ ss) ok", properties.is_in_ok (s, ss))

--			ss := some_sets_a & same_set_a (s)
--			assert ("same_set_a (s) ∈ ss", s ∈ ss)
--			assert ("same_set_a (s) ∈ ss ok", properties.is_in_ok (s, ss))

--			ss := some_sets_a / same_set_a (s)
--			assert ("not (same_set_a (s) ∈ ss)", not (s ∈ ss))
--			assert ("not (same_set_a (s) ∈ ss) ok", properties.is_in_ok (s, ss))

--			ss := some_sets_a
--			assert ("is_in", s ∈ ss ⇒ True)
--			assert ("is_in_ok", properties.is_in_ok (s, ss))
		end

feature -- Test routines (Construction)

	test_with
			-- Test {SET}.with.
		note
			testing: "covers/{SET}.with"
		local
			s: like set_to_be_tested
			a, b, c: A
		do
			s := o
			a := some_object_a
--			assert ("{a}", (s & a) ≍ singleton (a))
			assert ("{a} ok", properties.with_ok (s, a))

			s := s & same_object_a (a)
			b := some_object_a
--			assert ("{a,b}", (s & b) ≍ (singleton (a) & b))
			assert ("{a,b} ok", properties.with_ok (s, b))

			s := s & same_object_a (b)
			c := some_object_a
--			assert ("{a,b,c}", (s & c) ≍ (singleton (a) & b & c))
			assert ("{a,b,c} ok", properties.with_ok (s, c))

			s := set_to_be_tested
			a := some_object_a
			assert ("with", attached (s & a))
			assert ("with_ok", properties.with_ok (s, a))
		end

	test_without
			-- Test {SET}.without.
		note
			testing: "covers/{SET}.without"
		local
			s: like set_to_be_tested
			a, b, c: A
		do
			s := o
			a := some_object_a
--			assert ("∅", (s / a) ≍ o)
			assert ("∅ ok", properties.without_ok (s, a))

			s := s & same_object_a (a)
--			assert ("still ∅", (s / a) ≍ o)
			assert ("still ∅ ok", properties.without_ok (s, a))

			b := some_other_object_a (s)
--			assert ("{a}", (s / b) ≍ singleton (a))
			assert ("{a} ok", properties.without_ok (s, b))

			s := s & same_object_a (b)
--			assert ("still {a}", (s / b) ≍ singleton (a))
			assert ("still {a} ok", properties.without_ok (s, b))

			c := some_other_object_a (s)
--			assert ("{a,b}", (s / c) ≍ (singleton (a) & b))
			assert ("{a,b} ok", properties.without_ok (s, c))

			s := s & same_object_a (c)
--			assert ("still {a,b}", (s / c) ≍ (singleton (a) & b))
			assert ("still {a,b} ok", properties.without_ok (s, c))

			s := set_to_be_tested
			a := some_object_a
			assert ("with", attached (s & a))
			assert ("without_ok", properties.without_ok (s, a))
		end

feature {NONE} -- Factory (element to be tested)

	set_to_be_tested: like some_immediate_set_a
			-- Set meant to be under tests
		do
			Result := some_immediate_set_a
		end

	set_to_be_tested_with_cardinality (n: NATURAL): like set_to_be_tested
			-- Set with `n' elements meant to be under tests
			--| TODO: Make `n' more general.
		require
			small_enough: n ≤ Max_count
		do
			from
				from
					Result := set_to_be_tested
				until
--					# Result ≥ n
					True
				loop
					Result := set_to_be_tested
				end
--			invariant
--				at_least_n: # Result ≥ n
			until
--				# Result = n
				True
			loop
				Result := Result.others
--			variant
--				down_to_n: {like new_set_a}.natural_as_integer (# Result - n)
			end
		ensure
--			n_elements: # Result = n
		end

feature {NONE} -- Factory (Set)

	o: like set_to_be_tested
			-- The empty set, i.e. {} or ∅
			--| TODO: Make it once? An attribute?
		do
			create Result.make_empty
		end

	singleton (a: A): STS_SET [A, EQ]
			-- Singleton in the form {`a'}
			--| TODO: DRY.
		do
			Result := o.singleton (a)
		ensure
--			definition: Result ≍ o.singleton (a)
		end

note
	copyright: "Copyright (c) 2012-2023, Rosivaldo F Alves"
	license: "[
		Eiffel Forum License v2
		(see http://www.eiffel.com/licensing/forum.txt)
		]"
	source: ""
end
