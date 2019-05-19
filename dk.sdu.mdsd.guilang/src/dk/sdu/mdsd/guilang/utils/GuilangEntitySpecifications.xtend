package dk.sdu.mdsd.guilang.utils

import dk.sdu.mdsd.guilang.generator.EntityInstance
import dk.sdu.mdsd.guilang.guilang.DotRef
import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.EntityRef
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
	
	private def <T extends Option> void addAllNestedUniqueOptions2(Entity entity, Specification specification, List<T> accumulator) {
		for(option : specification.options) {
			if(option instanceof UnitInstanceOption) {
				addAllNestedUniqueOptions2(entity, option.instanceSpecification, accumulator)
			} else {
				val ref = specification.ref
				var Entity entityRef
				if(ref instanceof EntityRef) {
					entityRef = ref.entity
					
				} else if (ref instanceof DotRef) {
					entityRef = ref.tailEntity
					// DotRef/DotRef/EntityRef
					// Use this to collect specifications from nested DotRef instance
//					for(e : ref.dotRefHierarchy) {
//						
//					}
				}
				if(entityRef === entity && accumulator.findFirst[a|a.class === option.class] === null) { // Checks if the option has an existing override
					accumulator.add(option as T)
				}			
			}
		}
	}
	
	private def Entity getTailEntity(DotRef ref) {
		var next = ref.ref
		while(next instanceof DotRef) {
			next = next.ref
		}
		return next.entity
	}
	
	private def List<Entity> getDotRefHierarchy(DotRef ref) {
		val list = new ArrayList<Entity>
		list.add(ref.entity)
		var next = ref.ref
		while(next instanceof DotRef) {
			list.add(next.entity)
			next = next.ref
		}
		list.add(next.entity)
		return list
	}
	
	private def <T extends Option> void gatherDotRefSpecifications(DotRef dotRef, List<Option> accumulator) {
		val next = dotRef.ref
		if(next instanceof DotRef) {
			next.gatherDotRefSpecifications(accumulator)
		} else if(next instanceof EntityRef) {
			
		}
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
