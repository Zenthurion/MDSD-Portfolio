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
import dk.sdu.mdsd.guilang.guilang.Root
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
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.EcoreUtil2

class HTMLGenerator implements ILanguageGenerator {
	
	@Inject extension GuilangEntitySpecifications specs
	@Inject extension GuilangModelUtils utils
	
	val GuilangGenerator gen
	val CSSGenerator css
	val Root root
	
	new(GuilangGenerator generator) {
		gen = generator
		css = new CSSGenerator(gen)
		root = gen.root
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
		val list = new ArrayList<Specification>
		//list.add(root.main.contents.specifications)
		'''
		<html>
			<head>
				<title>«gen.title.toFirstUpper» GUI</title>
				«IF root.debug === false»
				<link rel="stylesheet" type="text/css" href="«gen.title».css" />
				«ELSE»
				<style>«css.generateCSS»</style>
				«ENDIF»
			</head>
			<body>
				«root.main.generateUnitOrInstance(list)»
			</body>
		</html>
		'''
	}
	
	def generateUnitOrInstance(EObject obj, List<Specification> specifications) {
		val unit = if(obj instanceof Unit) obj else if(obj instanceof UnitInstance) obj.unit else null
		
		if(unit === null) {
			println("Can't generate Unit or UnitInstance from " + obj)
			return ""
		}
		
		val relevant = specifications.filter[s|s.entity === obj]
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
		if(obj instanceof UnitInstance) {
			val overrides = EcoreUtil2.getContainerOfType(obj, Unit)?.contents.specifications.list.filter[s|s.entity == obj]
			if(overrides !== null)
				list.addAll(overrides)
		} 
		list.addAll(unit.contents.specifications.list)
		return unit.contents.layout.generate(list)
	}
	
	def dispatch generate(Vertical layout, List<Specification> specifications) {
		val hasName = hasName(layout)
		'''
		<div «IF hasName»id="«layout.name»" «ENDIF»class="vertical «layout.getAdditionalClasses(specifications)»">
		«FOR e : layout.entities»
			«e.generate(specifications)»
		«ENDFOR»
		</div>
		'''
	}
	
	def dispatch generate(Horizontal layout, List<Specification> specifications) {
		'''
		<div «IF layout.hasName»id="«layout.name»" «ENDIF»class="horizontal «layout.getAdditionalClasses(specifications)»">
		«FOR e : layout.entities»
			«e.generate(specifications)»
		«ENDFOR»
		</div>
		'''
	}
	
	def dispatch generate(Button button, List<Specification> specifications) {
		'''
		<input type="button" id="«button.name»" class="button«button.getAdditionalClasses(specifications)»«IF false» medium«ENDIF»" value="«button.getTextValue(specifications)»"></input>
		'''
	}
	
	
	
//	def gen(EntityObject obj) {
//		switch(obj.entity) {
//			Label: 
//				'''
//				<div id="«obj.name»" class="label«getAdditionalClasses(obj.entity)»">«obj.text»</div>
//				'''
//			Button:
//				'''
//				<input type="button" id="«obj.name»" class="button" value="«obj.text»"></input>
//				'''
//		}
//		
//	}
	
	def dispatch generate(Label label, List<Specification> specifications) {
		'''
		<div id="«label.name»" class="label«label.getAdditionalClasses(specifications)»">«label.getTextValue(specifications)»</div>
		'''
	}
	
	def dispatch generate(Input input, List<Specification> specifications) {
		'''
		<input type="text" id="«input.name»" class="input«input.getAdditionalClasses(specifications)»" value="«input.getTextValue(specifications)»"></input>
		'''
	}
	
	def dispatch generate(Checkbox checkbox, List<Specification> specifications) {
		'''
		<input type="checkbox"" id="«checkbox.name»" class="checkbox«checkbox.getAdditionalClasses(specifications)»"></input>
		'''
	}
	
	def dispatch generate(TextArea textArea, List<Specification> specifications) {
		'''
		<textarea cols="40" rows="5" id="«textArea.name»" class="text-area«textArea.getAdditionalClasses(specifications)»">«textArea.getTextValue(specifications)»</textarea>
		'''
	}
	
	def dispatch generate(UnitInstance entity, List<Specification> specifications) {
		return generateUnitOrInstance(entity, specifications)
	}
	
	def getAdditionalClasses(Entity entity, List<Specification> specifications) {
		//if(entity.name === null || entityOverrides.get(entity.name)  === null) return ""
		var res = ""
//		for(o : entityOptions.get(entity.name)) {
//			switch(o) {
//				SizeOption: res += " " + o.value
//			}
//		}
		return res
	}
}
