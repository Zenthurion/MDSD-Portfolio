package dk.sdu.mdsd.guilang.utils

import com.google.inject.Inject
import dk.sdu.mdsd.guilang.generator.EntityInstance
import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.Option
import dk.sdu.mdsd.guilang.guilang.Ref
import dk.sdu.mdsd.guilang.guilang.Specification
import dk.sdu.mdsd.guilang.guilang.UnitInstance
import dk.sdu.mdsd.guilang.guilang.UnitInstanceOption
import dk.sdu.mdsd.guilang.guilang.impl.TextValueImpl
import java.util.ArrayList
import java.util.List

class GuilangEntitySpecifications3 {
	@Inject extension GuilangModelUtils utils
	
	new() {
		utils = new GuilangModelUtils
	}
	
	def List<Specification> getRelevantSpecifications(UnitInstance unitInstance, EntityInstance owner, List<Specification> existing) {
		// TODO: Get specifications for the specific entity
		// TODO: Check for nested specifications which are relevant
		
		if(existing !== null) {
			//println("stop")
		}
		
		val relevant = new ArrayList<Specification>
		
		for(specification : existing) {
			for(entity : specification.ref.hierarchy) {
				if(entity === unitInstance) {
					for(option : specification.options) {
						if(option instanceof UnitInstanceOption) {
							relevant.add(option.instanceSpecification)
						}
					}
					relevant.add(specification) // Consider only adding if there is more than only instanceoption specifications
				}
			}
		}
		
		return relevant
	}

	def <T extends Option> List<T> getUniqueOptions(Entity entity, EntityInstance owner, List<Specification> specifications) {
		// TODO: Check specifications for the specific entity
		// TODO: Check specifications for nested unit instance specifications matching the dotref hierarchy of the entity
	
		val options = new ArrayList<T>
		if(entity.name == 'l1') {
			//println("stop")
		}
		for(specification : specifications) {
			entity.addAllNestedUniqueOptions(owner, specification, options)
		}
		
		return options
	}
	
	private def <T extends Option> void addAllNestedUniqueOptions(Entity entity, EntityInstance owner, Specification specification, List<T> accumulator) {
		for(option : specification.options) {
			if(option instanceof UnitInstanceOption) {
				entity.addAllNestedUniqueOptions(owner, option.instanceSpecification, accumulator)
			} else {
				if(entity.name == 'l1' && specification.ref.entity.name == 'l1') {
					//println("stop")
				}
				if(entity.areSameInstance(owner, specification.ref)) {
					if(accumulator.findFirst[a|a.class === option.class] === null) { // Checks if the option has an existing override
						accumulator.add(option as T)
					}	
				}
			}
		}
	}
	
	private def boolean areSameInstance(Entity entity, EntityInstance owner, Ref ref) {
		val references = ref.getHierarchy.reverse
		val entities = entity.getHierarchy(owner).reverse
		
		if(entity.name != ref.entity.name) {
			//print("skipping")
			return false
		}
		
		if(entity.name == 'l1') {
			//println("stop")
		}
		
		if(references.size < entities.size) {
			// false?
		} else {
			for(var i = 0; i < entities.size; i++) {
				if(references.get(i) !== entities.get(i)){
					println(entity.name + " and " + ref.entity.name + " do not share parents...")
					return false
				}
			}	
			return true
		}
			
		println(entity.name + " and " + ref.entity.name + " are not the same...")
		
		return false
	}

	def <T extends Option> T getOption(EntityInstance instance, Class<T> type) {
		for (o : instance.options) {
			if (type.isInstance(o)) {
				return o as T
			}
		}
		return null
	}

	def getTextValue(EntityInstance instance) {
		val textOption = getOption(instance, TextValueImpl)

		return if(textOption === null) "" else textOption.value
	}
}
