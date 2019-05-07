package dk.sdu.mdsd.guilang.utils

import com.google.inject.Inject
import dk.sdu.mdsd.guilang.generator.EntityObject
import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.Option
import dk.sdu.mdsd.guilang.guilang.Root
import dk.sdu.mdsd.guilang.guilang.Unit
import dk.sdu.mdsd.guilang.guilang.UnitInstance
import dk.sdu.mdsd.guilang.guilang.UnitInstanceOption
import java.util.ArrayList
import java.util.Collection
import java.util.HashMap
import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.EcoreUtil2

class GuilangEntitySpecifications2 {
//
//	@Inject extension GuilangModelUtils
//
//	Root root
//	Map<Entity, EntityObject2> data
//	
//	def initialiseEntitySpecifications(Root root) {
//		this.root = root
//		data = new HashMap
//		if (root.main.contents.specifications !== null) {
//			
//			// First Pass - Collect all entities
//			val entities = EcoreUtil2.getAllContentsOfType(root, Entity).filter[e|e.name !== null && e.name !== ""]
//			val unitInstances = getEntities(root.main.contents.layout).filter(UnitInstance)
//			for(e : entities) {
//				if(!(e instanceof UnitInstance)) {
//					val obj = new EntityObject2(e, root)
//					data.put(e, obj)
//					
//					obj.addOptions(getOptionsForEntity(e, root.main))
//				} 
//			}
//			
//			for(u : unitInstances) {
//				processUnitInstance(u, root)
//			}
//			
//			println("Entities added")
//		}
//		println("Overrides Initialised ")
//	}
//	
//	def void processUnitInstance(UnitInstance instance, EObject previousContext) {	
//		val entities = EcoreUtil2.getAllContentsOfType(instance.unit, Entity).filter[e|e.name !== null && e.name !== ""]
//		val unitInstances = getEntities(instance.unit.contents.layout).filter(UnitInstance)
//		for(e : entities) {
//			if(!(e instanceof UnitInstance)) {
//				val obj = new EntityObject2(e, instance)
//				val outer = data.get(e).getEntityOBjectWithContextOrLowest(previousContext)
//				if(outer !== null)
//					outer.templateObject = obj
//				
//				obj.addOptions(getOptionsForEntity(e, instance.unit))
//			} 
//		}
//		for(u : unitInstances) {
//			processUnitInstance(u, instance)
//		}
//	}
//	
//	def Collection<Option> getOptionsForEntity(Entity entity, Unit context) {
//		val list = new ArrayList<Option>
//		val specification = context.contents.specifications.list.findFirst[s|s.entity === entity]
//		
//		
//		if(specification !== null)
//			list.addAll(specification.options)
//			
//		return list
//	}
//	
//	// Look recursively into UnitInstanceSpecifications to obtain a full set of options! :D
//
//	
//		
//		
//	def getText(EntityObject entity) {
//		
//	}
//	
	

}