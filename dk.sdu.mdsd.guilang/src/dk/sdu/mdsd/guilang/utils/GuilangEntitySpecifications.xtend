package dk.sdu.mdsd.guilang.utils

import dk.sdu.mdsd.guilang.generator.EntityInstance
import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.Option
import dk.sdu.mdsd.guilang.guilang.Specification
import dk.sdu.mdsd.guilang.guilang.UnitInstanceOption
import dk.sdu.mdsd.guilang.guilang.impl.TextValueImpl
import java.util.ArrayList
import java.util.List

class GuilangEntitySpecifications {

	def <T extends Option> T getOption(Entity entity, List<Specification> specifications, Class<T> type) {
		for (specification : specifications) {
			var res = getNestedOption(entity, specification, type)
			if(res !== null) return res
		}
		
		return null
	}
	
	def <T extends Option> T getOption(EntityInstance instance, Class<T> type) {
		for(o : instance.options) {
			if(type.isInstance(o)) {
				return o as T
			} 
		}
		return null
	}

	private def <T extends Option> T getNestedOption(Entity entity, Specification specification, Class<T> type) {
		for (option : specification.options) {
			// specification.ref is not correct (old had specification.entity)
			if (specification.ref === entity && type.isInstance(option)) { // Can't check for entity earlier as UnitInstanceOptions have them nested
				return option as T;
			} else if (option instanceof UnitInstanceOption) {
				var res = getNestedOption(entity, option.instanceSpecification, type)
				if(res !== null) return res
			}
		}
		return null
	}
	
	def <T extends Option> List<T> getUniqueOptions(Entity entity, List<Specification> specifications) {
		val list = new ArrayList<T>
		for (specification : specifications) {
			addAllNestedUniqueOptions(entity, specification, list)
		}
		
		return list
	}
	
	private def <T extends Option> void addAllNestedUniqueOptions(Entity entity, Specification specification, List<T> accumulator) {
		for (option : specification.options) {
			// specification.ref is not correct (old had specification.entity)
			if (specification.ref === entity && accumulator.findFirst[a|a.class === option.class] === null) { // Can't check for entity earlier as UnitInstanceOptions have them nested
				accumulator.add(option as T)
			} else if (option instanceof UnitInstanceOption) {
				addAllNestedUniqueOptions(entity, option.instanceSpecification, accumulator)
			}
		}
	}

	def <T extends Option> boolean hasOption(Entity entity, List<Specification> containers, Class<T> type) {
		return getOption(entity, containers, type) !== null
	}

	def getTextValue(Entity entity, List<Specification> specifications) {
		if (specifications === null) 
			return ""
		
		val textOption = getOption(entity, specifications, TextValueImpl)
		
		return if(textOption === null) "" else textOption.value
	}

	def getTextValue(EntityInstance instance) {
		val textOption = getOption(instance, TextValueImpl)
		
		return if(textOption === null) "" else textOption.value
	}
}
