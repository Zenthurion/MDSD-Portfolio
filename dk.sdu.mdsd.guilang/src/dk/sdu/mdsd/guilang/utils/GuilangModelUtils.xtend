package dk.sdu.mdsd.guilang.utils

import java.util.ArrayList
import java.util.List
import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.Layout

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
}