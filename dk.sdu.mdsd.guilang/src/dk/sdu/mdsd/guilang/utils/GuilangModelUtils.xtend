package dk.sdu.mdsd.guilang.utils

import dk.sdu.mdsd.guilang.generator.EntityInstance
import dk.sdu.mdsd.guilang.guilang.DotRef
import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.Layout
import dk.sdu.mdsd.guilang.guilang.Ref
import dk.sdu.mdsd.guilang.guilang.Unit
import dk.sdu.mdsd.guilang.guilang.UnitInstance
import dk.sdu.mdsd.guilang.guilang.impl.UnitInstanceImpl
import java.util.ArrayList
import java.util.List

class GuilangModelUtils {
	def List<Entity> getEntities(Layout layout) {
		var list = new ArrayList<Entity>()

		list.add(layout)
		for (e : layout.entities) {
			if (e instanceof Layout)
				list.addAll(getEntities(e))
			else
				list.add(e)
		}
		return list
	}

	def List<Entity> getEntities(UnitInstance instance) {
		if(instance.unit.contents === null || instance.unit.contents.layout === null) return new ArrayList<Entity>
		return getEntities(instance.unit)
	}

	def List<Entity> getEntities(Unit unit) {
		if(unit.contents === null || unit.contents.layout === null) return new ArrayList<Entity>
		return getEntities(unit.contents.layout)
	}

	def boolean hasCyclicReference(Unit unit) {
		var units = new ArrayList<Unit>
		units.add(unit)
		for (e : unit.entities.filter(UnitInstanceImpl)) {
			if (e.basicGetUnit.name !== null && units.searchForCyclichReference(e.basicGetUnit)) {
				return true
			}
		}
		return false
	}

	private def boolean searchForCyclichReference(List<Unit> pastUnits, Unit toCheck) {
		if (pastUnits.contains(toCheck)) {
			return true
		}

		var units = new ArrayList<Unit>
		units.addAll(pastUnits)
		units.add(toCheck)
		for (e : toCheck.entities.filter(UnitInstanceImpl)) {
			if (e.basicGetUnit.name !== null) {
				if (searchForCyclichReference(units, e.basicGetUnit)) {
					return true
				}
			}
		}
		return false
	}

	def hasName(Entity entity) {
		return entity.name !== null && entity.name !== ""
	}
	
	def getShortName(Class<?> c) {
		var res = c.canonicalName
		return res.substring(res.lastIndexOf('.') + 1, res.length - 4)
	}

	def List<Entity> getHierarchy(Ref ref) {
		val list = new ArrayList<Entity>
		list.add(ref.entity)
		if (ref instanceof DotRef) {
			var next = ref.ref
			while (next instanceof DotRef) {
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

		while (parent !== null) {
			if (!(parent.entity instanceof Layout)) {
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
