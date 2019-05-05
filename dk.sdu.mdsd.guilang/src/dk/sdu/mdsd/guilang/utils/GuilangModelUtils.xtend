package dk.sdu.mdsd.guilang.utils

import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.Layout
import dk.sdu.mdsd.guilang.guilang.Specification
import dk.sdu.mdsd.guilang.guilang.Specifications
import dk.sdu.mdsd.guilang.guilang.Unit
import dk.sdu.mdsd.guilang.guilang.UnitContents
import dk.sdu.mdsd.guilang.guilang.UnitInstance
import dk.sdu.mdsd.guilang.guilang.UnitInstanceOption
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.EcoreUtil2

class GuilangModelUtils {
	def List<Entity> getEntities(Layout layout) {
		var list = new ArrayList<Entity>()
		
		list.add(layout)
		for(e : layout.entities) {
			if(e instanceof Layout) 
				list.addAll(getEntities(e))
			else 
				list.add(e)
		}
		return list
	}
	
	static def <T extends EObject> T deepClone(T obj) {
		var clone = EcoreUtil2.copy(obj)
		switch(clone) {
			Unit: {
				clone.contents = deepClone(clone.contents)
			}
			UnitContents: {
				clone.layout = deepClone(clone.layout)
				clone.specifications = deepClone(clone.specifications)
			}
			Layout: {
				var list = new BasicEList
				for(e : clone.entities){
					list.add(deepClone(e))
				}
				clone.entities.clear()
				for(e : list){
					clone.entities.add(e)
				}
			}
			UnitInstance: {
				clone.unit = deepClone(clone.unit)
			}
			Specifications: {
				var list = new BasicEList
				for(e : clone.list){
					list.add(deepClone(e))
				}
				clone.list.clear()
				for(e : list){
					clone.list.add(e)
				}
			}
			Specification: {
				clone.entity = deepClone(clone.entity)
				var list = new BasicEList
				for(e : clone.options){
					list.add(deepClone(e))
				}
				clone.options.clear()
				for(e : list){
					clone.options.add(e)
				}
			}
			UnitInstanceOption: {
				clone.instanceSpecification = deepClone(clone.instanceSpecification)
			}
			default: {
				println("Deep clone implementation missing for " + obj + " shallow clone used instead")
			}
		}
		return clone
	}
}