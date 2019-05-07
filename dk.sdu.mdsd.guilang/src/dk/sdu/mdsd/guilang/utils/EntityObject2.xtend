package dk.sdu.mdsd.guilang.utils

import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.Option
import java.util.ArrayList
import java.util.Collection
import java.util.List
import org.eclipse.emf.ecore.EObject

class EntityObject2 {
	EObject context
	Entity entity
	EntityObject2 templateObject
	List<Option> options

	new(Entity entity, EObject context) {
		this.entity = entity
		this.context = context

		options = new ArrayList<Option>
	}

	new(Entity entity, EObject context, EntityObject2 templateObject) {
		this(entity, context)
		setTemplateObject(templateObject)
	}

	def getEntity() {
		return entity
	}

	def getContext() {
		return context
	}

	def getTemplateObject() {
		return templateObject
	}

	def setTemplateObject(EntityObject2 templateObject) {
		if (templateObject.entity !== entity)
			throw new IllegalArgumentException("TemplateObject for EntityObject must be of the same entity instance")
		if (templateObject.context === context)
			throw new IllegalArgumentException("Can't have TemplateObject with same context as containing EntityObject")

		this.templateObject = templateObject
	}

	def EntityObject2 getEntityObjectWithContext(EObject context) {
		if(this.context === context) return this
		return if(templateObject === null) null else getEntityObjectWithContext(templateObject.context)
	}
	
	def EntityObject2 getEntityOBjectWithContextOrLowest(EObject context) {
		var res = getEntityObjectWithContext(context)
		if(res !== null) return res
		res = this
		while(res.templateObject !== null)
			res = templateObject
		return res
	}

	def addOptions(Collection<Option> options) {
		val list = new ArrayList<Option>(this.options)
		
		for (o : options) {
			val match = this.options.findFirst[op|op.class == o.class]
			if (match !== null) {
				list.remove(match)
			}
			list.add(o)
		}
		this.options.clear
		this.options.addAll(list)
	}

	def List<Option> getOptions() {
		val list = new ArrayList<Option>
		list.addAll(options)
		if(templateObject !== null) list.addAll(templateObject.getOptions)
		return list
	}
}
