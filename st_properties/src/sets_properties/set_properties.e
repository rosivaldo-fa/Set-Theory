﻿note
	description: "Object that checks whether the properties verified within set theory hold for an implementation of {STS_SET}"
	author: "Rosivaldo F Alves"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SET_PROPERTIES [A, EQ -> STS_EQUALITY [A]]

inherit
	ELEMENT_PROPERTIES
		rename
			is_in_ok as element_is_in_ok,
			is_not_in_ok as element_is_not_in_ok
		end

feature -- Access

	o: like o_anchor
			-- The empty set
		deferred
		ensure
			is_empty: Result.is_empty
		end

	current_universe: like universe_anchor
			-- The current "Universe", i.e. set with every object currently in system memory whose type conforms to {A}.
			-- Notice that this "universe" may change from a call to another.
		deferred
		end

	eq: EQ
			-- Equality for objects like {A}
		deferred
		end

feature -- Properties (Primitive)

	is_empty_ok (s: STS_SET [A, EQ]): BOOLEAN
			-- Do the properties verified within set theory hold for {STS_SET}.is_empty?
		do
			check
				u: attached current_universe as u
--				definition: s.is_empty = (
--					s ≍ (
--						u | agent  (x: A): BOOLEAN
--							do
--								Result := False
--							end
--						)
--					)
				has_nothing: s.is_empty = (u |∀ agent s.does_not_have)
--				no_element: s.is_empty = (# s = 0)
--				uniqueness: s.is_empty = (s ≍ o)
			then
				Result := True
			end
		end

	any_ok (s: STS_SET [A, EQ]): BOOLEAN
			-- Do the properties verified within set theory hold for {STS_SET}.any?
		do
			if not s.is_empty then
				check
					membership: s ∋ s.any
--					building_up: s ≍ (s.others & s.any)
				then
				end
			end
			Result := True
		end

	others_ok (s: STS_SET [A, EQ]): BOOLEAN
			-- Do the properties verified within set theory hold for {STS_SET}.others?
		do
			if s.is_empty then
				check
--					same_set: s.others ≍ s
--					no_element: # s.others = # s
				then
				end
			else
				check
--					decomposing: s.others ≍ (s / s.any)
--					strict_subset: s.others ⊂ s
--					one_element_less: # s.others = # s - 1
				then
				end
			end
			check
--				subset: s.others ⊆ s
			then
				Result := True
			end
		end

feature -- Properties (Membership)

	is_in_ok (s: STS_SET [A, EQ]; ss: STS_SET [STS_SET [A, EQ], STS_EQUALITY [STS_SET [A, EQ]]]): BOOLEAN
			-- Do the properties verified within set theory hold for {STS_SET}.is_in?
		do
			check
				require_non_emptiness: s ∈ ss ⇒ not ss.is_empty
			then
				Result := True
			end
		end

	is_not_in_ok (s: STS_SET [A, EQ]; ss: STS_SET [STS_SET [A, EQ], STS_EQUALITY [STS_SET [A, EQ]]]): BOOLEAN
			-- Do the properties verified within set theory hold for {STS_SET}.is_not_in?
		do
			check
				definition: s ∉ ss = ss ∌ s
				sufficient_emptiness: ss.is_empty ⇒ s ∉ ss
			then
				Result := True
			end
		end

	has_ok (s: STS_SET [A, EQ]; a: A): BOOLEAN
			-- Do the properties verified within set theory hold for {STS_SET}.has?
		do
			check
				u: attached current_universe as u
				require_non_emptiness: s ∋ a ⇒ not s.is_empty
				universe_has_everything: u ∋ a
--				uniqueness: s ∋ a = s |∃! agent s.equality_holds (?, a)
				has_own_elements: s |∀ agent s.has
			then
				Result := True
			end
		end

	does_not_have_ok (s: STS_SET [A, EQ]; a: A): BOOLEAN
			-- Do the properties verified within set theory hold for {STS_SET}.does_not_have?
		do
			check
--				definition: s ∌ a = s |∄ agent s.equality_holds (?, a)
--				has_own_elements: s |∄ agent s.does_not_have
				empty_set_has_nothing: o ∌ a
			then
				Result := True
			end
		end

feature -- Properties (Construction)

	with_ok (s: STS_SET [A, EQ]; a: A): BOOLEAN
			-- Do the properties verified within set theory hold for {STS_SET}.with?
		do
			check
				u: attached current_universe as u
--				definition: (s & a) ≍ (u | agent u.ored (agent s.has, agent u.equality_holds (?, a), ?))
--				by_union: (s & a) ≍ s ∪ singleton (a)
--				same_cardinality: s ∋ a ⇒ # (s & a) = # s
--				incremented_cardinality: s ∌ a ⇒ # (s & a) = # s + 1
			then
				Result := True
			end
		end

	without_ok (s: STS_SET [A, EQ]; a: A): BOOLEAN
			-- Do the properties verified within set theory hold for {STS_SET}.without?
		do
			check
				u: attached current_universe as u
--				definition: (s / a) ≍ (u | agent anded (agent s.has, agent negated (agent s.equality_holds (?, a), ?), ?))
				excluded: (s / a) ∌ a
				every_other_element: s |∀ agent implied (agent negated (agent s.equality_holds (?, a), ?), agent (s / a).has, ?)
--				nothing_else: (s / a) ⊆ s
--				same_cardinality: s ∌ a ⇒ # (s / a) = # s
--				decremented_cardinality: s ∋ a ⇒ # (s / a) = # s - 1
			then
				Result := True
			end
		end

feature -- Properties (Quality)

	is_singleton_ok (s: STS_SET [A, EQ]): BOOLEAN
			-- Do the properties verified within set theory hold for {STS_SET}.is_singleton?
		do
			check
--				definition: s.is_singleton = (# s = 1)
--				by_construction: s.is_singleton ⇒ not s.is_empty and then s ≍ singleton (s.any)
			then
				Result := True
			end
		end

feature -- Factory

	singleton (a: A): STS_SET [A, EQ]
			-- Singleton in the form {`a'}
			-- TODO: DRY
		do
			Result := o.singleton (a)
		ensure
--			definition: Result ≍ o.singleton (a)
		end

feature -- Predicate

	negated (p: PREDICATE [A]; x: A): BOOLEAN
			-- Logical negation of `p' (`x'), i.e. is `p' (`x') false?
			-- TODO: Pull it up?
		do
			Result := not p (x)
		ensure
			class
			definition: Result = not p (x)
		end

	anded (p1, p2: PREDICATE [A]; x: A): BOOLEAN
			-- Do `p1' (`x') and `p2' (`x') hold?
			-- TODO: Pull it up?
		do
			Result := p1 (x) and p2 (x)
		ensure
			class
			definition: Result = (p1 (x) and p2 (x))
		end

	implied (p1, p2: PREDICATE [A]; x: A): BOOLEAN
			-- If `p1' (`x') holds, does `p2' (`x') hold too, i.e. does `p1' (`x') imply `p2' (`x')?
			-- TODO: Pull it up?
		do
			Result := p1 (x) ⇒ p2 (x)
		ensure
			class
			definition: Result = (p1 (x) ⇒ p2 (x))
		end

feature {NONE} -- Anchor

	o_anchor: STS_SET [A, EQ]
			-- Anchor for `o'
		do
			Result := o
		end

	universe_anchor: STS_SET [A, EQ]
			-- Anchor for `current_universe'
		do
			Result := current_universe
		end

note
	copyright: "Copyright (c) 2012-2023, Rosivaldo F Alves"
	license: "[
		Eiffel Forum License v2
		(see http://www.eiffel.com/licensing/forum.txt)
		]"
	source: ""
end
