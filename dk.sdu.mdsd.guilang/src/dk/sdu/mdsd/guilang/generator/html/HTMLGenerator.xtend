package dk.sdu.mdsd.guilang.generator.html

import com.google.inject.Inject
import dk.sdu.mdsd.guilang.generator.GuilangGenerator
import dk.sdu.mdsd.guilang.generator.ILanguageGenerator
import dk.sdu.mdsd.guilang.guilang.Button
import dk.sdu.mdsd.guilang.guilang.Checkbox
import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.Horizontal
import dk.sdu.mdsd.guilang.guilang.Input
import dk.sdu.mdsd.guilang.guilang.Label
import dk.sdu.mdsd.guilang.guilang.Layout
import dk.sdu.mdsd.guilang.guilang.SizeOption
import dk.sdu.mdsd.guilang.guilang.Specification
import dk.sdu.mdsd.guilang.guilang.Specifications
import dk.sdu.mdsd.guilang.guilang.TextArea
import dk.sdu.mdsd.guilang.guilang.Unit
import dk.sdu.mdsd.guilang.guilang.UnitContents
import dk.sdu.mdsd.guilang.guilang.UnitInstance
import dk.sdu.mdsd.guilang.guilang.UnitInstanceOption
import dk.sdu.mdsd.guilang.guilang.Vertical
import dk.sdu.mdsd.guilang.utils.GuilangModelUtils
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

class HTMLGenerator extends GuilangGenerator implements ILanguageGenerator {
	
	@Inject extension GuilangModelUtils
	
	var CSSGenerator css
	
	new(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		initialise(resource, fsa, context)
		
		css = new CSSGenerator(resource, fsa, context)
	}
	
	override generate() {
		fsa.generateFile(title + '.html', generateHTML())
		if (root.debug === false)
		{
			css.generate()			
		}
	}
	
	def generateHTML() {
		'''
		<html>
			<head>
				<title>«title.toFirstUpper» GUI</title>
				«IF root.debug === false»
				<link rel="stylesheet" type="text/css" href="«title».css" />
				«ELSE»
				<style>«css.generateCSS»</style>
				«ENDIF»
			</head>
			<body>
				«root.main.contents.layout.generate(null)»
			</body>
		</html>
		'''
	}
	
	def generateLayout(Layout layout, Specification context){
		
		var String type
		switch(layout) {
			Vertical: type = "vertical"
			Horizontal: type = "horizontal"
		}
		
		'''
		<div «IF layout.name !== null && layout.name !== ""»id="«layout.name»" «ENDIF»class="«type»«getAdditionalClasses(layout)»">
		«FOR e : layout.entities»
			«e.generate(context.orLookup(layout))»
		«ENDFOR»
		</div>
		'''
	}
	
	def dispatch generate(Vertical entity, Specification context) {
		return generateLayout(entity, context)
	}
	
	def dispatch generate(Horizontal entity, Specification context) {
		return generateLayout(entity, context)
	}
	
	def dispatch generate(Button entity, Specification context) {
		applySpecificationContext(entity, context)
		val name = entity.name
		val additional = getAdditionalClasses(entity)
		val hasOptions = hasOption(entity, SizeOption)
		val con = context.orLookup(entity)
		val textVal = getTextValue(entity, con)
		'''
		<input type="button" id="«name»" class="button«additional»«IF !hasOptions» medium«ENDIF»" value="«textVal»"></input>
		'''
	}
	
	def dispatch generate(Label entity, Specification context) {
		applySpecificationContext(entity, context)
		val text = getTextValue(entity, context.orLookup(entity))
		'''
		<div id="«entity.name»" class="label«getAdditionalClasses(entity)»">«text»</div>
		'''
	}
	
	def dispatch generate(Input entity, Specification context) {
		applySpecificationContext(entity, context)
		val text = getTextValue(entity, context.orLookup(entity))
		'''
		<input type="text" id="«entity.name»" class="input«getAdditionalClasses(entity)»" value="«text»"></input>
		'''
	}
	
	def dispatch generate(Checkbox entity, Specification context) {
		applySpecificationContext(entity, context)
		'''
		<input type="checkbox"" id="«entity.name»" class="checkbox«getAdditionalClasses(entity)»"></input>
		'''
	}
	
	def dispatch generate(TextArea entity, Specification context) {
		applySpecificationContext(entity, context)
		'''
		<textarea cols="40" rows="5" id="«entity.name»" class="text-area«getAdditionalClasses(entity)»">«getTextValue(entity, context.orLookup(entity))»</textarea>
		'''
	}
	
	def dispatch generate(UnitInstance entity, Specification context) {
		applySpecificationContext(entity, context)
		mergeOverridesWithTemplate(entity, entity.unit)
		'''
		<div id="«entity.name»" class="template«getAdditionalClasses(entity)»">
			«entity.unit.contents.layout.generate(getSpecification(entity))»
		</div>
		'''
	}
	
	def orLookup(Specification s, Entity e){
		return if (s !== null) s else getSpecification(e)
	}
	
	def getAdditionalClasses(Entity entity) {
		if(entity.name === null || entityOptions.get(entity.name)  === null) return ""
		var res = ""
		for(o : entityOptions.get(entity.name)) {
			switch(o) {
				SizeOption: res += " " + o.value
			}
		}
		return res
	}
}
