package dk.sdu.mdsd.guilang.utils

import dk.sdu.mdsd.guilang.guilang.BackgroundColor
import dk.sdu.mdsd.guilang.guilang.Button
import dk.sdu.mdsd.guilang.guilang.Checkbox
import dk.sdu.mdsd.guilang.guilang.DimOption
import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.Horizontal
import dk.sdu.mdsd.guilang.guilang.Input
import dk.sdu.mdsd.guilang.guilang.Label
import dk.sdu.mdsd.guilang.guilang.SizeOption
import dk.sdu.mdsd.guilang.guilang.TextArea
import dk.sdu.mdsd.guilang.guilang.TextColor
import dk.sdu.mdsd.guilang.guilang.TextSize
import dk.sdu.mdsd.guilang.guilang.TextValue
import dk.sdu.mdsd.guilang.guilang.UnitInstance
import dk.sdu.mdsd.guilang.guilang.Vertical
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import dk.sdu.mdsd.guilang.guilang.UnitInstanceOption

class EntitySpecificationsProvider {
	Map<Class<? extends Entity>, List<EntityOption>> entityOptions
	
	new() {
		entityOptions = new HashMap
		
		// Available Entities
		val vertical = new ArrayList<EntityOption>
		val horizontal = new ArrayList<EntityOption>
		val button = new ArrayList<EntityOption>
		val label = new ArrayList<EntityOption>
		val input = new ArrayList<EntityOption>
		val checkbox = new ArrayList<EntityOption>
		val textArea = new ArrayList<EntityOption>
		val unitInstance = new ArrayList<EntityOption>
		
		// Available Options
		val dimensions = new EntityOption(DimOption, "dimensions")
		val size = new EntityOption(SizeOption, "size")
		val bgColor = new EntityOption(BackgroundColor, "bg-color")
		val textColor = new EntityOption(TextColor, "text-color")
		val textSize = new EntityOption(TextSize, "text-size")
		val textValue = new EntityOption(TextValue, "text")
		val unitInstanceOption = new EntityOption(UnitInstanceOption, "")
		
		// Assign Options
		vertical.addAll(dimensions, bgColor)
		horizontal.addAll(dimensions, bgColor)		
		button.addAll(size, bgColor, textColor, textSize, textValue)
		label.addAll(textColor, textSize, textValue)
		input.addAll(textColor, textSize, textValue, bgColor)
		checkbox.addAll(size)
		textArea.addAll(dimensions, bgColor, textSize, textColor, textValue)
		unitInstance.addAll(unitInstanceOption)
		
		// Populate Map
		entityOptions.put(Vertical, vertical)
		entityOptions.put(Horizontal, horizontal)
		entityOptions.put(Button, button)
		entityOptions.put(Label, label)
		entityOptions.put(Input, input)
		entityOptions.put(Checkbox, checkbox)
		entityOptions.put(TextArea, textArea)
		entityOptions.put(UnitInstance, unitInstance)
	}
	
	def getSpecifications(Class<? extends Entity> type){
		var res = entityOptions.getOrDefault(type, null)
		if(res !== null) return res
		
		for(c : entityOptions.keySet) {
			if(c.isAssignableFrom(type)) {
				return entityOptions.get(c)
			}
		} 
		return null
	}	
}