package dk.sdu.mdsd.guilang.generator.html

import com.google.inject.Inject
import dk.sdu.mdsd.guilang.generator.EntityInstance
import dk.sdu.mdsd.guilang.generator.GuilangGenerator
import dk.sdu.mdsd.guilang.generator.ILanguageGenerator
import dk.sdu.mdsd.guilang.guilang.Button
import dk.sdu.mdsd.guilang.guilang.Checkbox
import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.Horizontal
import dk.sdu.mdsd.guilang.guilang.Input
import dk.sdu.mdsd.guilang.guilang.Label
import dk.sdu.mdsd.guilang.guilang.Root
import dk.sdu.mdsd.guilang.guilang.SizeOption
import dk.sdu.mdsd.guilang.guilang.Specification
import dk.sdu.mdsd.guilang.guilang.TextArea
import dk.sdu.mdsd.guilang.guilang.Unit
import dk.sdu.mdsd.guilang.guilang.UnitInstance
import dk.sdu.mdsd.guilang.guilang.UnitInstanceOption
import dk.sdu.mdsd.guilang.guilang.Vertical
import dk.sdu.mdsd.guilang.utils.GuilangEntitySpecifications
import dk.sdu.mdsd.guilang.utils.GuilangModelUtils
import java.util.ArrayList
import java.util.List

class HTMLGenerator implements ILanguageGenerator {
	
	@Inject extension GuilangEntitySpecifications specs
	@Inject extension GuilangModelUtils utils
	
	val GuilangGenerator gen
	val CSSGenerator css
	val Root root
	
	val List<EntityInstance> entityInstances
	
	new(GuilangGenerator generator) {
		gen = generator
		css = new CSSGenerator(gen, this)
		root = gen.root
		
		entityInstances = new ArrayList<EntityInstance>
	}
	
	override generate() {
		if(specs === null) {
			specs = new GuilangEntitySpecifications
		}
		if(utils === null) {
			utils = new GuilangModelUtils
		}
		
		gen.fsa.generateFile(gen.title + '.html', generateHTML())
		if (gen.root.debug === false)
		{
			css.generate()			
		}
	}
	
	def generateHTML() { 
		'''
		<html>
			<head>
				<title>«gen.title.toFirstUpper» GUI</title>
				«IF root.debug === false»
				<link rel="stylesheet" type="text/css" href="«gen.title».css" />
				<link rel="stylesheet" type="text/css" href="defaults.css" />
				<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
				«ELSE»
				<style>«css.generateCSS»</style>
				«ENDIF»
			</head>
			<body>
				<div class="container">
					<div id="main" class="mx-auto card shadow ">
						«generateInitial(root)»
					</div>
				</div>
				«addPostScripts»
			</body>
		</html>
		'''
	}
	
	def CharSequence generateInitial(Root root) {
		val specifications = new ArrayList<Specification>
		root.main.generateMainOrInstance(null, specifications)
	}
	
	def CharSequence generateMainOrInstance(Unit unit, EntityInstance instance, List<Specification> specifications) {
		var List<Specification> relevant 
		if(instance !== null) {
			if(instance.entity instanceof UnitInstance) {				
				relevant = getRelevantSpecifications(instance.entity, specifications) // find relevant from passed through specifications
				if(unit.contents.specifications !== null && unit.contents.specifications.list !== null)
					relevant.addAll(unit.contents.specifications.list.filter[s|s.entity !== null && s.entity == instance.entity]) // find relevant from the current unit's context
			}
		} else {
			relevant = new ArrayList<Specification>
		}
		
		if(unit.contents.specifications !== null && unit.contents.specifications.list !== null)
			relevant.addAll(unit.contents.specifications.list)
			
		return addInstance(unit.contents.layout, instance, relevant).generate(relevant)
	}
	
	def getRelevantSpecifications(Entity entity, List<Specification> specifications) {
		val relevant = specifications.filter[s|s.entity === entity]
		val list = new ArrayList<Specification>()
		if(relevant !== null) {
			for(r : relevant) {
				for(o : r.options) {
					if(o instanceof UnitInstanceOption) {
						list.add(o.instanceSpecification)
					}
				}
			}
		}
		return list
	}
	
	def CharSequence generate(EntityInstance instance, List<Specification> specifications) {
		switch(instance.entity) {
			UnitInstance:
				'''
				<div id=«instance.identifier»>
					«generateMainOrInstance((instance.entity as UnitInstance).unit, instance, specifications)»
				</div>
				'''
			Vertical: {
				var coreClasses = "container vertical d-flex flex-column"
				'''
				<div «IF instance.hasIdentifier»id="«instance.identifier»" «ENDIF»class="«coreClasses» «instance.additionalClasses»">
					«FOR e : (instance.entity as Vertical).entities»
						<div class="d-flex mx-auto flex-row">
						«addInstance(e, instance,  specifications).generate(specifications)»
						</div>
					«ENDFOR»
				</div>
				'''	
			}
			Horizontal: {
				var coreClasses = "container horizontal d-flex flex-row"
				'''
				<div «IF instance.hasIdentifier»id="«instance.identifier»" «ENDIF»class="«coreClasses» «instance.additionalClasses»">
					«FOR e : (instance.entity as Horizontal).entities»
						«addInstance(e, instance,  specifications).generate(specifications)»
					«ENDFOR»
				</div>
				'''
			}
			Button: {
				var coreClasses = "element button btn btn-primary"
				'''
				<input type="button" id="«instance.identifier»" class="«coreClasses» «instance.additionalClasses»«IF false» medium«ENDIF»" value="«instance.getTextValue»"></input>
				'''
			}
			Label:
				'''
				<div id="«instance.identifier»" class="element label «instance.additionalClasses»">«instance.getTextValue»</div>
				'''
			Input:
				'''
				<input type="text" id="«instance.identifier»" class="element input form-control «instance.additionalClasses»" value="«instance.getTextValue»"></input>
				'''
			Checkbox:
				'''
				<input type="checkbox"" id="«instance.identifier»" class="element checkbox«instance.additionalClasses»"></input>
				'''
			TextArea:
				'''
				<textarea cols="40" rows="5" id="«instance.identifier»" class="element text-area«instance.additionalClasses»">«instance.getTextValue»</textarea>
				'''
			default: null
		}
	}
	
	def addPostScripts() {
		'''
		<scripts>
		</scripts>
		'''
	}
	
	def addInstance(Entity entity, EntityInstance owner, List<Specification> specifications) {
		var namespace = if(owner !== null) (if(owner.identifier === null) owner.namespace else owner.identifier) else ""
		val instance = new EntityInstance(entity, namespace, getUniqueOptions(entity,specifications))
		entityInstances.add(instance)
		return instance
	}
	
	def additionalClasses(EntityInstance instance) {
		val classes = new ArrayList<String>
		
		for(o : instance.options) {
			switch(o) {
				SizeOption: classes.add(o.value) 
			}
		}
		return classes.join(' ')
	}
	
	def getEntityInstances() {
		return entityInstances
	}
}
