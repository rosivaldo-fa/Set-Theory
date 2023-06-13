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
			test_is_not_in as element_test_is_not_in,
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
				s := s.o -- ∖ same_set_a (s)
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
			assert ("∅", s.others ≍ o)
			assert ("∅ ok", properties.others_ok (s))

			s := s & some_object_a
			check
				is_not_empty: not s.is_empty -- s = {a}
			end
			a := same_object_a (s.any)
			assert ("{a}", s.others ≍ o)
			assert ("{a} ok", properties.others_ok (s))

			s := s & some_other_object_a (s)
			check
				is_not_empty_2: not s.others.is_empty -- s = {a,b}
			end
			b := same_set_a (s.others).any
			assert ("{a,b}", s.others ≍ (o & b))
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
			assert ("{a,b,c}", s.others ≍ (s.o & b & c))
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

	test_is_not_in
			-- Test {STS_SET}.is_not_in.
			-- Test {SET}.is_not_in.
		note
			testing: "covers/{STS_SET}.is_not_in"
			testing: "covers/{SET}.is_not_in"
		local
			s: like set_to_be_tested
			ss: like some_set_sa
		do
			s := set_to_be_tested
			ss := some_set_references_a / s
			assert ("s ∉ ss", s ∉ ss)
			assert ("s ∉ ss ok", properties.is_in_ok (s, ss))

			ss := some_set_references_a & s
			assert ("not (s ∉ ss)", not (s ∉ ss))
			assert ("not (s ∉ ss) ok", properties.is_in_ok (s, ss))

			ss := some_set_standard_objects_a / s.standard_twin
			assert ("s.standard_twin ∉ ss", s ∉ ss)
			assert ("s.standard_twin ∉ ss ok", properties.is_in_ok (s, ss))

			ss := some_set_standard_objects_a & s.standard_twin
			assert ("not (s.standard_twin ∉ ss)", not (s ∉ ss))
			assert ("not (s.standard_twin ∉ ss) ok", properties.is_in_ok (s, ss))

			ss := some_set_objects_a / s.twin
			assert ("s.twin ∉ ss", s ∉ ss)
			assert ("s.twin ∉ ss ok", properties.is_in_ok (s, ss))

			ss := some_set_objects_a & s.twin
			assert ("not (s.twin ∉ ss)", not (s ∉ ss))
			assert ("not (s.twin ∉ ss) ok", properties.is_in_ok (s, ss))

			ss := some_set_deep_objects_a / s.deep_twin
			assert ("s.deep_twin ∉ ss", s ∉ ss)
			assert ("s.deep_twin ∉ ss ok", properties.is_in_ok (s, ss))

			ss := some_set_deep_objects_a & s.deep_twin
			assert ("not (s.deep_twin ∉ ss)", not (s ∉ ss))
			assert ("not (s.deep_twin ∉ ss) ok", properties.is_in_ok (s, ss))

--			ss := some_sets_a / same_set_a (s)
--			assert ("same_set_a (s) ∉ ss", s ∉ ss)
--			assert ("same_set_a (s) ∉ ss ok", properties.is_in_ok (s, ss))

--			ss := some_sets_a & same_set_a (s)
--			assert ("not (same_set_a (s) ∉ ss)", not (s ∉ ss))
--			assert ("not (same_set_a (s) ∉ ss) ok", properties.is_in_ok (s, ss))

--			ss := some_sets_a
--			assert ("is_in", s ∉ ss ⇒ True)
--			assert ("is_in_ok", properties.is_in_ok (s, ss))
		end

	test_has
			-- Test {SET}.has.
		note
			testing: "covers/{SET}.has"
		local
			a: A
			s: like set_to_be_tested
		do
			a := some_object_a
			s := set_to_be_tested & same_object_a (a)
			assert ("s ∋ a", s ∋ a)
			assert ("s ∋ a ok", properties.has_ok (s, a))

			s := set_to_be_tested / same_object_a (a)
			assert ("not (s ∋ a)", not (s ∋ a))
			assert ("s ∋ a ok", properties.has_ok (s, a))

			s := set_to_be_tested
			assert ("has", s ∋ a ⇒ True)
			assert ("has_ok", properties.has_ok (s, a))
		end

	test_does_not_have
			-- Test {STS_SET}.does_not_have.
			-- Test {SET}.does_not_have.
		note
			testing: "covers/{STS_SET}.does_not_have"
			testing: "covers/{SET}.does_not_have"
		local
			a: A
			s: like set_to_be_tested
		do
			a := some_object_a
			s := set_to_be_tested / same_object_a (a)
			assert ("s ∌ a", s ∌ a)
			assert ("s ∌ a ok", properties.does_not_have_ok (s, a))

			s := set_to_be_tested & same_object_a (a)
			assert ("not (s ∌ a)", not (s ∌ a))
			assert ("s ∌ same_a ok", properties.does_not_have_ok (s, a))

			s := set_to_be_tested
			assert ("does_not_have", s ∌ a ⇒ True)
			assert ("does_not_have_ok", properties.does_not_have_ok (s, a))
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
			assert ("∅ & a", (s & a) ≍ singleton (a))
			assert ("∅ & a ok", properties.with_ok (s, a))

			s := s & same_object_a (a)
			assert ("{a} & a", (s & a) ≍ singleton (a))
			assert ("{a} & a ok", properties.with_ok (s, a))

			b := some_object_a
			assert ("{a} & b", (s & b) ≍ (singleton (a) & b))
			assert ("{a} & b ok", properties.with_ok (s, b))

			s := s & same_object_a (b)
			assert ("{a,b} & b", (s & b) ≍ (singleton (a) & b))
			assert ("{a,b} & b ok", properties.with_ok (s, b))

			c := some_object_a
			assert ("{a,b} & c", (s & c) ≍ (singleton (a) & b & c))
			assert ("{a,b} & c ok", properties.with_ok (s, c))

			s := s & same_object_a (c)
			assert ("{a,b,c} & c", (s & c) ≍ (singleton (a) & b & c))
			assert ("{a,b,c} & c ok", properties.with_ok (s, c))

			s := set_to_be_tested
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
			assert ("∅ / a", (s / a) ≍ o)
			assert ("∅ / a ok", properties.without_ok (s, a))

			s := s & same_object_a (a)
			assert ("{a} / a", (s / a) ≍ o)
			assert ("{a} / a ok", properties.without_ok (s, a))

			b := some_other_object_a (s)
			assert ("{a} / b", (s / b) ≍ singleton (a))
			assert ("{a} / b ok", properties.without_ok (s, b))

			s := s & same_object_a (b)
			assert ("{a,b} / b", (s / b) ≍ singleton (a))
			assert ("{a,b} / b ok", properties.without_ok (s, b))

			c := some_other_object_a (s)
			assert ("{a,b} / c", (s / c) ≍ (singleton (a) & b))
			assert ("{a,b} / c ok", properties.without_ok (s, c))

			s := s & same_object_a (c)
			assert ("{a,b,c} / c", (s / c) ≍ (singleton (a) & b))
			assert ("{a,b,c} / c ok", properties.without_ok (s, c))

			s := set_to_be_tested
			assert ("withou", attached (s / a))
			assert ("without_ok", properties.without_ok (s, a))
		end

feature -- Test routines (Quality)

	test_is_singleton
			-- Test {STS_SET}.is_singleton.
			-- Test {SET}.is_singleton.
		note
			testing: "covers/{STS_SET}.is_singleton"
			testing: "covers/{SET}.is_singleton"
		local
			a, b: A
			s: like set_to_be_tested
		do
			a := some_object_a
			s := o & same_object_a (a)
			assert ("s.is_singleton", s.is_singleton)
			assert ("s.is_singleton ok", properties.is_singleton_ok (s))

			inspect
				next_random_item \\ 2
			when 0 then
				s := o
			when 1 then
				b := some_other_object_a (s)
				s := set_to_be_tested & same_object_a (a) & same_object_a (b)
			end
			assert ("not s.is_singleton", not s.is_singleton)
			assert ("not s.is_singleton ok", properties.is_singleton_ok (s))

			s := set_to_be_tested
			assert ("is_singleton", s.is_singleton ⇒ True)
			assert ("is_singleton_ok", properties.is_singleton_ok (s))
		end

feature -- Test routines (Measurement)

	test_cardinality
			-- Test {SET}.cardinality.
		note
			testing: "covers/{SET}.cardinality"
		local
			s: like set_to_be_tested
		do
			s := o
			assert ("∅", # s = 0)
			assert ("∅ ok", properties.cardinality_ok (s))

			s := s & some_object_a
			assert ("{a}", # s = 1)
			assert ("{a} ok", properties.cardinality_ok (s))

			s := s & some_other_object_a (s)
			assert ("{a,b}", # s = 2)
			assert ("{a,b} ok", properties.cardinality_ok (s))

			s := s & some_other_object_a (s)
			assert ("{a,b,c}", # s = 3)
			assert ("{a,b,c} ok", properties.cardinality_ok (s))

			s := set_to_be_tested
			assert ("cardinality", attached # s)
			assert ("cardinality_ok", properties.cardinality_ok (s))
		end

feature -- Test routines (Comparison)

	test_equals
			-- Test {SET}.equals.
		note
			testing: "covers/{SET}.equals"
		local
			a: A
			s: like set_to_be_tested
			s2: like some_set_a
		do
			s := set_to_be_tested
			s2 := same_set_a (s)
			assert ("s ≍ s2", s ≍ s2)
			assert ("s ≍ s2 ok", properties.equals_ok (s, s2, some_set_a))

			a := some_object_a
			inspect
				next_random_item \\ 2
			when 0 then
				s := s & same_object_a (a)
				s2 := s2 / same_object_a (a)
			when 1 then
				s := s / same_object_a (a)
				s2 := s2 & same_object_a (a)
			end
			assert ("not (s ≍ s2)", not (s ≍ s2))
			assert ("(s ≍ s2) ok", properties.equals_ok (s, s2, some_set_a))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("equals", s ≍ s2 ⇒ True)
			assert ("equals ok", properties.equals_ok (s, s2, some_set_a))
		end

	test_unequals
			-- Test {STS_SET}.unequals.
			-- Test {SET}.unequals.
		note
			testing: "covers/{STS_SET}.unequals"
			testing: "covers/{SET}.unequals"
		local
			a: A
			s: like set_to_be_tested
			s2: like some_set_a
		do
			a := some_object_a
			inspect
				next_random_item \\ 2
			when 0 then
				s := set_to_be_tested & same_object_a (a)
				s2 := some_set_a / same_object_a (a)
			when 1 then
				s := set_to_be_tested / same_object_a (a)
				s2 := some_set_a & same_object_a (a)
			end
			assert ("s ≭ s2", s ≭ s2)
			assert ("s ≭ s2 ok", properties.unequals_ok (s, s2))

			s := set_to_be_tested
			s2 := same_set_a (s)
			assert ("not (s ≭ s2)", not (s ≭ s2))
			assert ("(s ≭ s2) ok", properties.unequals_ok (s, s2))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("unequals", s ≭ s2 ⇒ True)
			assert ("unequals ok", properties.unequals_ok (s, s2))
		end

	test_is_subset
			-- Test {SET}.is_subset.
		note
			testing: "covers/{SET}.is_subset"
		local
			a: A
			s: like set_to_be_tested
			s2: like some_set_a
		do
			s := set_to_be_tested
			s2 := some_set_a --∪ same_set_a (s)
			assert ("s ⊆ s2", s ⊆ s2)
			assert ("s ⊆ s2 ok", properties.is_subset_ok (s, s2, some_set_a))

			a := some_object_a
			s := set_to_be_tested & same_object_a (a)
			s2 := some_set_a / same_object_a (a)
			assert ("not (s ⊆ s2)", not (s ⊆ s2))
			assert ("not (s ⊆ s2) ok", properties.is_subset_ok (s, s2, some_set_a))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("is_subset", s ⊆ s2 ⇒ True)
			assert ("is_subset ok", properties.is_subset_ok (s, s2, some_set_a))
		end

	test_is_not_subset
			-- Test {STS_SET}.is_not_subset.
			-- Test {SET}.is_not_subset.
		note
			testing: "covers/{STS_SET}.is_not_subset"
			testing: "covers/{SET}.is_not_subset"
		local
			a: A
			s: like set_to_be_tested
			s2: like some_set_a
		do
			a := some_object_a
			s := set_to_be_tested & same_object_a (a)
			s2 := some_set_a / same_object_a (a)
			assert ("s ⊈ s2", s ⊈ s2)
			assert ("s ⊈ s2 ok", properties.is_not_subset_ok (s, s2))

			s := set_to_be_tested
			s2 := some_set_a --∪ same_set_a (s)
			assert ("not (s ⊈ s2)", not (s ⊈ s2))
			assert ("not (s ⊈ s2) ok", properties.is_not_subset_ok (s, s2))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("is_not_subset", s ⊈ s2 ⇒ True)
			assert ("is_not_subset ok", properties.is_not_subset_ok (s, s2))
		end

	test_is_superset
			-- Test {STS_SET}.is_superset.
			-- Test {SET}.is_superset.
		note
			testing: "covers/{STS_SET}.is_superset"
			testing: "covers/{SET}.is_superset"
		local
			a: A
			s: like set_to_be_tested
			s2: like some_set_a
		do
			s := set_to_be_tested
			s2 := some_set_a--∩ same_set_a (s)
			assert ("s ⊇ s2", s ⊇ s2)
			assert ("s ⊇ s2 ok", properties.is_superset_ok (s, s2, some_set_a))

			a := some_object_a
			s := set_to_be_tested / same_object_a (a)
			s2 := some_set_a & same_object_a (a)
			assert ("not (s ⊇ s2)", not (s ⊇ s2))
			assert ("not (s ⊇ s2) ok", properties.is_superset_ok (s, s2, some_set_a))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("is_superset", s ⊇ s2 ⇒ True)
			assert ("is_superset ok", properties.is_superset_ok (s, s2, some_set_a))
		end

	test_is_not_superset
			-- Test {STS_SET}.is_not_superset.
			-- Test {SET}.is_not_superset.
		note
			testing: "covers/{STS_SET}.is_not_superset"
			testing: "covers/{SET}.is_not_superset"
		local
			a: A
			s: like set_to_be_tested
			s2: like some_set_a
		do
			a := some_object_a
			s := set_to_be_tested / same_object_a (a)
			s2 := some_set_a & same_object_a (a)
			assert ("s ⊉ s2", s ⊉ s2)
			assert ("s ⊉ s2 ok", properties.is_not_superset_ok (s, s2))

			s := set_to_be_tested
			s2 := some_set_a--∩ same_set_a (s)
			assert ("not (s ⊉ s2)", not (s ⊉ s2))
			assert ("not (s ⊉ s2) ok", properties.is_not_superset_ok (s, s2))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("is_not_superset", s ⊉ s2 ⇒ True)
			assert ("is_not_superset ok", properties.is_not_superset_ok (s, s2))
		end

	test_is_comparable
			-- Test {STS_SET}.is_comparable.
			-- Test {SET}.is_comparable.
		note
			testing: "covers/{STS_SET}.is_comparable"
			testing: "covers/{SET}.is_comparable"
		local
			a, b: A
			s: like set_to_be_tested
			s2: like some_set_a
		do
			if next_random_item \\ 2 = 0 then
				s := set_to_be_tested
				s2 := some_set_a --∪ same_set_a (s)
			else
				s := set_to_be_tested
				s2 := some_set_a--∩ same_set_a (s)
			end
			assert ("s.is_comparable (s2)", s.is_comparable (s2))
			assert ("s.is_comparable (s2) ok", properties.is_comparable_ok (s, s2, some_set_a))

			a := some_object_a
			b := some_other_object_a (singleton (same_object_a (a)))
			if next_random_item \\ 2 = 0 then
				s := set_to_be_tested & same_object_a (a) / same_object_a (b)
				s2 := (some_set_a / same_object_a (a)) & same_object_a (b)
			else
				s := (set_to_be_tested / same_object_a (a)) & same_object_a (b)
				s2 := some_set_a & same_object_a (a) / same_object_a (b)
			end
			assert ("not s.is_comparable (s2)", not s.is_comparable (s2))
			assert ("not s.is_comparable (s2) ok", properties.is_comparable_ok (s, s2, some_set_a))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("is_comparable", s.is_comparable (s2) ⇒ True)
			assert ("is_comparable_ok", properties.is_comparable_ok (s, s2, some_set_a))
		end

	test_is_not_comparable
			-- Test {STS_SET}.is_not_comparable.
			-- Test {SET}.is_not_comparable.
		note
			testing: "covers/{STS_SET}.is_not_comparable"
			testing: "covers/{SET}.is_not_comparable"
		local
			a, b: A
			s: like set_to_be_tested
			s2: like some_set_a
		do
			a := some_object_a
			b := some_other_object_a (singleton (same_object_a (a)))
			if next_random_item \\ 2 = 0 then
				s := set_to_be_tested & same_object_a (a) / same_object_a (b)
				s2 := (some_set_a / same_object_a (a)) & same_object_a (b)
			else
				s := (set_to_be_tested / same_object_a (a)) & same_object_a (b)
				s2 := some_set_a & same_object_a (a) / same_object_a (b)
			end
			assert ("s.is_not_comparable (s2)", s.is_not_comparable (s2))
			assert ("s.is_not_comparable (s2) ok", properties.is_not_comparable_ok (s, s2, some_set_a))

			if next_random_item \\ 2 = 0 then
				s := set_to_be_tested
				s2 := some_set_a --∪ same_set_a (s)
			else
				s := set_to_be_tested
				s2 := some_set_a--∩ same_set_a (s)
			end
			assert ("not s.is_not_comparable (s2)", not s.is_not_comparable (s2))
			assert ("not s.is_not_comparable (s2) ok", properties.is_not_comparable_ok (s, s2, some_set_a))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("is_not_comparable", s.is_not_comparable (s2) ⇒ True)
			assert ("is_not_comparable_ok", properties.is_not_comparable_ok (s, s2, some_set_a))
		end

	test_is_strict_subset
			-- Test {SET}.is_strict_subset.
		note
			testing: "covers/{SET}.is_strict_subset"
		local
			a: A
			s: like set_to_be_tested
			s2: like some_set_a
		do
			s := set_to_be_tested
			s2 := some_set_a--∪ same_set_a (s)
			 & some_other_object_a (s)
			assert ("s ⊂ s2", s ⊂ s2)
			assert ("s ⊂ s2 ok", properties.is_strict_subset_ok (s, s2, some_set_a))

			s := set_to_be_tested
			if next_random_item \\ 2 = 0 then
				s2 := same_set_a (s)
			else
				a := some_object_a
				s := s & same_object_a (a)
				s2 := some_set_a / same_object_a (a)
			end
			assert ("not (s ⊂ s2)", not (s ⊂ s2))
			assert ("not (s ⊂ s2) ok", properties.is_strict_subset_ok (s, s2, some_set_a))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("is_strict_subset", s ⊂ s2 ⇒ True)
			assert ("is_strict_subset_ok", properties.is_strict_subset_ok (s, s2, some_set_a))
		end

	test_is_not_strict_subset
			-- Test {STS_SET}.is_not_strict_subset.
			-- Test {SET}.is_not_strict_subset.
		note
			testing: "covers/{STS_SET}.is_not_strict_subset"
			testing: "covers/{SET}.is_not_strict_subset"
		local
			a: A
			s: like set_to_be_tested
			s2: like some_set_a
		do
			s := set_to_be_tested
			if next_random_item \\ 2 = 0 then
				s2 := same_set_a (s)
			else
				a := some_object_a
				s := s & same_object_a (a)
				s2 := some_set_a / same_object_a (a)
			end
			assert ("s ⊄ s2", s ⊄ s2)
			assert ("s ⊄ s2 ok", properties.is_not_strict_subset_ok (s, s2))

			s := set_to_be_tested
			s2 := some_set_a--∪ same_set_a (s)
			 & some_other_object_a (s)
			assert ("not (s ⊄ s2)", not (s ⊄ s2))
			assert ("not (s ⊄ s2) ok", properties.is_not_strict_subset_ok (s, s2))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("is_not_strict_subset", s ⊄ s2 ⇒ True)
			assert ("is_not_strict_subset_ok", properties.is_not_strict_subset_ok (s, s2))
		end

	test_is_strict_superset
			-- Test {STS_SET}.is_strict_superset.
			-- Test {SET}.is_strict_superset.
		note
			testing: "covers/{STS_SET}.is_strict_superset"
			testing: "covers/{SET}.is_strict_superset"
		local
			a: A
			s: like set_to_be_tested
			s2: like some_set_a
		do
			a := some_object_a
			s := set_to_be_tested & same_object_a (a)
			s2 := some_set_a / same_object_a (a)
			s2 := s2--∩ same_set_a (s)
			assert ("s ⊃ s2", s ⊃ s2)
			assert ("s ⊃ s2 ok", properties.is_strict_superset_ok (s, s2, some_set_a))

			s := set_to_be_tested
			if next_random_item \\ 2 = 0 then
				s2 := same_set_a (s)
			else
				a := some_object_a
				s := s / same_object_a (a)
				s2 := some_set_a & same_object_a (a)
			end
			assert ("not (s ⊃ s2)", not (s ⊃ s2))
			assert ("not (s ⊃ s2) ok", properties.is_strict_superset_ok (s, s2, some_set_a))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("is_strict_superset", s ⊃ s2 ⇒ True)
			assert ("is_strict_superset_ok", properties.is_strict_superset_ok (s, s2, some_set_a))
		end

	test_is_not_strict_superset
			-- Test {STS_SET}.is_not_strict_superset.
			-- Test {STISET}.is_not_strict_superset.
		note
			testing: "covers/{STS_SET}.is_not_strict_superset"
			testing: "covers/{STISET}.is_not_strict_superset"
		local
			a: A
			s: like set_to_be_tested
			s2: like some_set_a
		do
			s := set_to_be_tested
			if next_random_item \\ 2 = 0 then
				s2 := same_set_a (s)
			else
				a := some_object_a
				s := s / same_object_a (a)
				s2 := some_set_a & same_object_a (a)
			end
			assert ("s ⊅ s2", s ⊅ s2)
			assert ("s ⊅ s2 ok", properties.is_not_strict_superset_ok (s, s2))

			a := some_object_a
			s := set_to_be_tested & same_object_a (a)
			s2 := some_set_a / same_object_a (a)
			s2 := s2--∩ same_set_a (s)
			assert ("not (s ⊅ s2)", not (s ⊅ s2))
			assert ("not (s ⊅ s2) ok", properties.is_not_strict_superset_ok (s, s2))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("is_not_strict_superset", s ⊅ s2 ⇒ True)
			assert ("is_not_strict_superset_ok", properties.is_not_strict_superset_ok (s, s2))
		end

	test_is_trivial_subset
			-- Test {SET}.is_trivial_subset.
		note
			testing: "covers/{SET}.is_trivial_subset"
		local
			s: like set_to_be_tested
			s2: like some_set_a
		do
			if next_random_item \\ 2 = 0 then
				s := o
				s2 := some_set_a
			else
				s := set_to_be_tested
				s2 := same_set_a (s)
			end
			assert ("s.is_trivial_subset (s2)", s.is_trivial_subset (s2))
			assert ("s.is_trivial_subset (s2) ok", properties.is_trivial_subset_ok (s, s2, some_set_a))

			s := set_to_be_tested & some_object_a
			if next_random_item \\ 2 = 0 then
				s2 := some_set_a--∩ same_set_a (s).others
			else
				s2 := some_set_a & some_other_object_a (s)
			end
			assert ("not s.is_trivial_subset (s2)", not s.is_trivial_subset (s2))
			assert ("not s.is_trivial_subset (s2) ok", properties.is_trivial_subset_ok (s, s2, some_set_a))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("is_trivial_subset", s.is_trivial_subset (s2) ⇒ True)
			assert ("is_trivial_subset_ok", properties.is_trivial_subset_ok (s, s2, some_set_a))
		end

	test_is_trivial_superset
			-- Test {STS_SET}.is_trivial_superset.
			-- Test {SET}.is_trivial_superset.
		note
			testing: "covers/{STS_SET}.is_trivial_superset"
			testing: "covers/{SET}.is_trivial_superset"
		local
			s: like set_to_be_tested
			s1, s2: like some_set_a
		do
			s := set_to_be_tested
			if next_random_item \\ 2 = 0 then
				s2 := some_set_a.o
			else
				s2 := same_set_a (s)
			end
			assert ("s.is_trivial_superset (s2)", s.is_trivial_superset (s2))
			assert ("s.is_trivial_superset (s2) ok", properties.is_trivial_superset_ok (s, s2, some_set_a))

			if next_random_item \\ 2 = 0 then
				s := set_to_be_tested
				s2 := some_set_a & some_other_object_a (s)
			else
				s2 := some_set_a & some_object_a
				s1 := set_to_be_tested--∪ s2
				 & some_other_object_a (s2)
			end
			assert ("not s.is_trivial_superset (s2)", not s.is_trivial_superset (s2))
			assert ("not s.is_trivial_superset (s2) ok", properties.is_trivial_superset_ok (s, s2, some_set_a))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("is_trivial_superset", s.is_trivial_superset (s2) ⇒ True)
			assert ("is_trivial_superset_ok", properties.is_trivial_superset_ok (s, s2, some_set_a))
		end

	test_is_proper_subset
			-- Test {SET}.is_proper_subset.
		note
			testing: "covers/{SET}.is_proper_subset"
		local
			a: A
			s: like set_to_be_tested
			s2: like some_set_a
		do
			s := set_to_be_tested & some_object_a
			s2 := some_set_a & some_other_object_a (s) --∪ same_set_a (s)
			assert ("s.is_proper_subset (s2)", s.is_proper_subset (s2))
			assert ("s.is_proper_subset (s2) ok", properties.is_proper_subset_ok (s, s2, some_set_a))

			inspect
				next_random_item \\ 3
			when 0 then
				s := o
				s2 := some_set_a
			when 1 then
				s := set_to_be_tested
				s2 := same_set_a (s)
			when 2 then
				a := some_object_a
				s := set_to_be_tested & same_object_a (a)
				s2 := some_set_a / same_object_a (a)
			end
			assert ("not s.is_proper_subset (s2)", not s.is_proper_subset (s2))
			assert ("not s.is_proper_subset (s2) ok", properties.is_proper_subset_ok (s, s2, some_set_a))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("is_proper_subset", s.is_proper_subset (s2) ⇒ True)
			assert ("is_proper_subset_ok", properties.is_proper_subset_ok (s, s2, some_set_a))
		end

	test_is_proper_superset
			-- Test {STS_SET}.is_proper_superset.
			-- Test {SET}.is_proper_superset.
		note
			testing: "covers/{STS_SET}.is_proper_superset"
			testing: "covers/{SET}.is_proper_superset"
		local
			a: A
			s: like set_to_be_tested
			s2: like some_set_a
		do
			s2 := some_set_a & some_object_a
			s := set_to_be_tested & some_other_object_a (s2) --∪ same_set_a (s2)			
			assert ("s.is_proper_superset (s2)", s.is_proper_superset (s2))
			assert ("s.is_proper_superset (s2) ok", properties.is_proper_superset_ok (s, s2, some_set_a))

			inspect
				next_random_item \\ 3
			when 0 then
				s2 := o
				s := set_to_be_tested
			when 1 then
				s2 := some_set_a
				s := o--∪ same_set_a (s2)
			when 2 then
				a := some_object_a
				s2 := some_set_a & same_object_a (a)
				s := set_to_be_tested / same_object_a (a)
			end
			assert ("not s.is_proper_superset (s2)", not s.is_proper_superset (s2))
			assert ("not s.is_proper_superset (s2) ok", properties.is_proper_superset_ok (s, s2, some_set_a))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("is_proper_superset", s.is_proper_superset (s2) ⇒ True)
			assert ("is_proper_superset_ok", properties.is_proper_superset_ok (s, s2, some_set_a))
		end

	test_is_disjoint
			-- Test {SET}.is_disjoint.
		note
			testing: "covers/{SET}.is_disjoint"
		local
			a: A
			s: like set_to_be_tested
			s2: like some_set_a
		do
			if next_random_item \\ 2 = 0 then
				s := set_to_be_tested
				s2 := some_set_a--∖ same_set_a (s)
			else
				s2 := some_set_a
				s := set_to_be_tested--∖ same_set_a (s2)
			end
			assert ("s.is_disjoint (s2)", s.is_disjoint (s2))
			assert ("s.is_disjoint (s2) ok", properties.is_disjoint_ok (s, s2, some_set_a))

			a := some_object_a
			s := set_to_be_tested & same_object_a (a)
			s2 := some_set_a & same_object_a (a)
			assert ("not s.is_disjoint (s2)", not s.is_disjoint (s2))
			assert ("not s.is_disjoint (s2) ok", properties.is_disjoint_ok (s, s2, some_set_a))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("is_disjoint", s.is_disjoint (s2) ⇒ True)
			assert ("is_disjoint_ok", properties.is_disjoint_ok (s, s2, some_set_a))
		end

	test_intersects
			-- Test {STS_SET}.intersects.
			-- Test {SET}.intersects.
		note
			testing: "covers/{STS_SET}.intersects"
			testing: "covers/{SET}.intersects"
		local
			a: A
			s: like set_to_be_tested
			s2: like some_set_a
		do
			a := some_object_a
			s := set_to_be_tested & same_object_a (a)
			s2 := some_set_a & same_object_a (a)
			assert ("s.intersects (s2)", s.intersects (s2))
			assert ("s.intersects (s2) ok", properties.intersects_ok (s, s2, some_set_a))

			if next_random_item \\ 2 = 0 then
				s := set_to_be_tested
				s2 := some_set_a--∖ same_set_a (s)
			else
				s2 := some_set_a
				s := set_to_be_tested--∖ same_set_a (s2)
			end
			assert ("not s.intersects (s2)", not s.intersects (s2))
			assert ("not s.intersects (s2) ok", properties.intersects_ok (s, s2, some_set_a))

			s := set_to_be_tested
			s2 := some_set_a
			assert ("intersects", s.intersects (s2) ⇒ True)
			assert ("intersects_ok", properties.intersects_ok (s, s2, some_set_a))
		end

feature -- Test routines (Quantifier)

	test_exists
			-- Test {SET}.exists.
		note
			testing: "covers/{SET}.exists"
		local
			a: A
			s: like set_to_be_tested
			p: PREDICATE [A]
		do
			p := agent (x: A): BOOLEAN
				do
					Result := x = Void or else x.out.hash_code \\ 2 = 0
				end
			from
				a := some_object_a
			until
				p (a)
			loop
				a := some_object_a
			end
			s := set_to_be_tested & same_object_a (a)
			assert ("s |∃ p", s |∃ p)
			assert ("s |∃ p ok", properties.exists_ok (s, p))

			s := set_to_be_tested | agent negated (p, ?)
			assert ("not (s |∃ p)", not (s |∃ p))
			assert ("not (s |∃ p) ok", properties.exists_ok (s, p))

			s := set_to_be_tested
			assert ("exists", (s |∃ p) ⇒ True)
			assert ("exists_ok", properties.exists_ok (s, p))
		end

	test_does_not_exist
			-- Test {STS_SET}.does_not_exist.
			-- Test {SET}.does_not_exist.
		note
			testing: "covers/{STS_SET}.does_not_exist"
			testing: "covers/{SET}.does_not_exist"
		local
			a: A
			s: like set_to_be_tested
			p: PREDICATE [A]
		do
			p := agent (x: A): BOOLEAN
				do
					Result := x = Void or else x.out.hash_code \\ 2 = 0
				end
			s := set_to_be_tested | agent negated (p, ?)
			assert ("s |∄ p", s |∄ p)
			assert ("s |∄ p ok", properties.does_not_exist_ok (s, p))

			from
				a := some_object_a
			until
				p (a)
			loop
				a := some_object_a
			end
			s := set_to_be_tested & same_object_a (a)
			assert ("not (s |∄ p)", not (s |∄ p))
			assert ("not (s |∄ p) ok", properties.does_not_exist_ok (s, p))

			s := set_to_be_tested
			assert ("does_not_exist", s |∄ p ⇒ True)
			assert ("does_not_exist_ok", properties.does_not_exist_ok (s, p))
		end

	test_exists_unique
			-- Test {SET}.exists_unique.
		note
			testing: "covers/{SET}.exists_unique"
		local
			a: A
			s: like set_to_be_tested
			p: PREDICATE [A]
		do
			p := agent (x: A): BOOLEAN
				do
					Result := x = Void or else x.out.hash_code \\ 2 = 0
				end
			from
				a := some_object_a
			until
				p (a)
			loop
				a := some_object_a
			end
			s := set_to_be_tested | agent negated (p, ?) & same_object_a (a)
			assert ("s |∃! p", s |∃! p)
			assert ("s |∃! p ok", properties.exists_unique_ok (s, p))

			if next_random_item \\ 2 = 0 then
				s := s / same_object_a (a)
			else
				from
					a := some_other_object_a (s)
				until
					p (a)
				loop
					a := some_other_object_a (s)
				end
				s := s & same_object_a (a)
			end
			assert ("not (s |∃! p)", not (s |∃! p))
			assert ("not (s |∃! p) ok", properties.exists_unique_ok (s, p))

			s := set_to_be_tested
			assert ("exists_unique", s |∃! p ⇒ True)
			assert ("exists_unique_ok", properties.exists_unique_ok (s, p))
		end

	test_exists_pair
			-- Test {SET}.exists_pair.
		note
			testing: "covers/{SET}.exists_pair"
		local
			a, b: A
			s: like set_to_be_tested
			p: PREDICATE [A, A]
		do
			p := agent (x, y: A): BOOLEAN
				do
					if x = Void then
						Result := y /= Void
					else
						Result := y = Void or else x.out.hash_code \\ 2 /= y.out.hash_code \\ 2
					end
				end
			from
				a := some_object_a
				b := some_object_a
			until
				p (a, b)
			loop
				a := some_object_a
				b := some_object_a
			end
			s := set_to_be_tested & a & b
			assert ("s.exists_pair (p)", s.exists_pair (p))
			assert ("s.exists_pair (p) ok", properties.exists_pair_ok (s, p))

			if next_random_item \\ 2 = 0 then
				s := set_to_be_tested | agent (ia_p: PREDICATE [A, A]; x, y: A): BOOLEAN do Result := not ia_p (x, y) end (p, a, ?)
			else
				s := set_to_be_tested | agent (ia_p: PREDICATE [A, A]; x, y: A): BOOLEAN do Result := not ia_p (x, y) end (p, ?, b)
			end
			assert ("not s.exists_pair (p)", not s.exists_pair (p))
			assert ("not s.exists_pair (p) ok", properties.exists_pair_ok (s, p))

			s := set_to_be_tested
			assert ("exists_pair", s.exists_pair (p) ⇒ True)
			assert ("exists_pair_ok", properties.exists_pair_ok (s, p))
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
					# Result ≥ n
				loop
					Result := set_to_be_tested
				end
			invariant
				at_least_n: # Result ≥ n
			until
				# Result = n
			loop
				Result := Result.others
			variant
				down_to_n: {SET [A, EQ]}.natural_as_integer (# Result - n)
			end
		ensure
			n_elements: # Result = n
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
			definition: Result ≍ o.singleton (a)
		end

feature -- Predicate

	binary_anded (p: PREDICATE [A]; x: A; q: PREDICATE [A]; y: A): BOOLEAN
			-- Does `p' (`x') and `q' (`y') hold?
			-- TODO: Pull it up?
		do
			Result := p (x) and q (y)
		ensure
			class
			definition: Result = (p (x) and q (y))
		end

note
	copyright: "Copyright (c) 2012-2023, Rosivaldo F Alves"
	license: "[
		Eiffel Forum License v2
		(see http://www.eiffel.com/licensing/forum.txt)
		]"
	source: ""

end
