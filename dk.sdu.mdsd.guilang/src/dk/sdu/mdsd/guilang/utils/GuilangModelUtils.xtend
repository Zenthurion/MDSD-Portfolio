package dk.sdu.mdsd.guilang.utils

import dk.sdu.mdsd.guilang.generator.EntityInstance
import dk.sdu.mdsd.guilang.guilang.DotRef
import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.Layout
import dk.sdu.mdsd.guilang.guilang.Ref
import dk.sdu.mdsd.guilang.guilang.Unit
import dk.sdu.mdsd.guilang.guilang.UnitInstance
import java.util.ArrayList
import java.util.List

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
	
	def List<Entity> getEntities(UnitInstance instance) {
		return getEntities(instance.unit)
	}
	
	def List<Entity> getEntities(Unit unit) {
		return getEntities(unit.contents.layout)
	}
	
	def hasName(Entity entity) {
		return entity.name !== null && entity.name !== ""
	}	
	
	def List<Entity> getHierarchy(Ref ref) {
		val list = new ArrayList<Entity>
		list.add(ref.entity)
		if(ref instanceof DotRef) {
			var next = ref.ref
			while(next instanceof DotRef) {
				list.add(next.entity)
				next = next.ref
			}
			list.add(next.entity)
		}
		return list.reverse
	}
	
	def List<Entity> getHierarchy(Entity entity, EntityInstance owner) {
		val list = new ArrayList<Entity>
		list.add(entity)
		var parent = owner
		
		while(parent !== null) {
			if(!(parent.entity instanceof Layout)) {
				list.add(parent.entity)
			}
			
			parent = parent.parent
		}
		
		return list.reverse
	}
	
	def Entity getTailEntity(DotRef ref) {
		return ref.entity
	}
}