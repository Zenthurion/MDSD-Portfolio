package org.sdu.mdsd.guilang.util

import java.util.HashMap
import java.util.Map
import org.sdu.mdsd.guilang.guilang.Button
import org.sdu.mdsd.guilang.guilang.Checkbox
import org.sdu.mdsd.guilang.guilang.Entity
import org.sdu.mdsd.guilang.guilang.Horizontal
import org.sdu.mdsd.guilang.guilang.Input
import org.sdu.mdsd.guilang.guilang.Label
import org.sdu.mdsd.guilang.guilang.TemplateInstance
import org.sdu.mdsd.guilang.guilang.TextArea
import org.sdu.mdsd.guilang.guilang.Vertical
import org.sdu.mdsd.guilang.guilang.impl.ButtonImpl
import org.sdu.mdsd.guilang.guilang.impl.CheckboxImpl
import org.sdu.mdsd.guilang.guilang.impl.HorizontalImpl
import org.sdu.mdsd.guilang.guilang.impl.InputImpl
import org.sdu.mdsd.guilang.guilang.impl.LabelImpl
import org.sdu.mdsd.guilang.guilang.impl.TemplateInstanceImpl
import org.sdu.mdsd.guilang.guilang.impl.TextAreaImpl
import org.sdu.mdsd.guilang.guilang.impl.VerticalImpl

class EntitySpecificationsProvider {
	Map<Class<? extends Entity>, EntityOptionsCollection> specifications 
	
	private new() {
		specifications = new HashMap
		
		var vertical = new EntityOptionsCollection(Vertical)
		var horizontal = new EntityOptionsCollection(Horizontal)
		
		var button = new EntityOptionsCollection(Button) 
		var label = new EntityOptionsCollection(Label) 
		var input = new EntityOptionsCollection(Input) 
		var checkbox = new EntityOptionsCollection(Checkbox)
		var textArea = new EntityOptionsCollection(TextArea)
		var template = new EntityOptionsCollection(TemplateInstance)
		
		// Define all possible options
		var dimensions = new EntityOption("Dimension", "dimensions")
		var size = new EntityOption("Size", "size")
		var bgColor = new EntityOption("Background Color", "bg-color")
		var textColor = new EntityOption("Text Color", "text-color")
		var textSize = new EntityOption("Text Size", "text-size")
		var textValue = new EntityOption("Text", "text")
		var textValidate = new EntityOption("Text Validation", "validate")
		var checkboxValidate = new EntityOption("Checkbox Validation", "validate")
		var require = new EntityOption("Require Elements", "require")
		
		// Assign options to entities
		vertical.add(dimensions, bgColor)
		horizontal.add(dimensions, bgColor)		
		button.add(size, bgColor, textColor, textValue, require)
		label.add(textColor, textSize, textValue)
		input.add(textColor, textSize, textValue, textValidate, require, bgColor)
		checkbox.add(checkboxValidate, size)
		textArea.add(dimensions, bgColor, textSize, textColor, textValue, textValidate, require)
		
		// Add to map
		specifications.put(Vertical, vertical);
		specifications.put(Horizontal, horizontal);
		specifications.put(Button, button);
		specifications.put(Label, label);
		specifications.put(Input, input);
		specifications.put(Checkbox, checkbox);
		specifications.put(TextArea, textArea);
		specifications.put(TemplateInstance, template);
		
		// Crude fix for Impl versions
		specifications.put(VerticalImpl, vertical);
		specifications.put(HorizontalImpl, horizontal);
		specifications.put(ButtonImpl, button);
		specifications.put(LabelImpl, label);
		specifications.put(InputImpl, input);
		specifications.put(CheckboxImpl, checkbox);
		specifications.put(TextAreaImpl, textArea);
		specifications.put(TemplateInstanceImpl, template);
	}
	
	def getSpecifications(Class<? extends Entity> type){
		return specifications.getOrDefault(type, null)
	}	
}