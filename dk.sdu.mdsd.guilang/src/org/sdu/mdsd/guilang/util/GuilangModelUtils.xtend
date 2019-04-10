package org.sdu.mdsd.guilang.util

import java.util.ArrayList
import java.util.List
import org.sdu.mdsd.guilang.guilang.Entity
import org.sdu.mdsd.guilang.guilang.Layout

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