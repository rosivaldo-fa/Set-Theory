note
	description: "test application root class"
	date: "$Date: 2019-09-11 18:27:54 +0000 (Wed, 11 Sep 2019) $"
	revision: "$Revision: 103504 $"

class
	APPLICATION

create
	make

feature  -- Initialization

	make
			-- Run application.
		local
			et: ELEMENT_TESTS
		do
			create et
		end

note
	copyright: "Copyright (c) 1984-2019, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
