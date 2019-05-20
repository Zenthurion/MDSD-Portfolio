package dk.sdu.mdsd.guilang.utils

import dk.sdu.mdsd.guilang.guilang.Option

class EntityOption {

	Class<? extends Option> option
	String key

	new(Class<? extends Option> option, String key) {
		this.option = option
		this.key = key
	}

	def getOption() {
		return option
	}

	def getKey() {
		return key
	}
}
