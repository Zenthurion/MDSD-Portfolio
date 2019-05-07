package dk.sdu.mdsd.guilang.generator.html

import dk.sdu.mdsd.guilang.generator.EntityInstance
import dk.sdu.mdsd.guilang.generator.GuilangGenerator
import dk.sdu.mdsd.guilang.generator.ILanguageGenerator
import dk.sdu.mdsd.guilang.guilang.Option
import dk.sdu.mdsd.guilang.guilang.impl.BackgroundColorImpl
import dk.sdu.mdsd.guilang.guilang.impl.DimOptionImpl
import dk.sdu.mdsd.guilang.guilang.impl.TextColorImpl
import dk.sdu.mdsd.guilang.guilang.impl.TextSizeImpl
import java.util.ArrayList

class CSSGenerator implements ILanguageGenerator {

	val GuilangGenerator gen
	val HTMLGenerator html
	
	new(GuilangGenerator generator, HTMLGenerator html) {
		gen = generator
		this.html = html
	}

	override void generate() {
		gen.fsa.generateFile(gen.title + '.css', generateCSS)
		
		gen.fsa.generateFile("defaults.css", generateDefaults)
	}

	def generateCSS() {
		'''
		«FOR instance : html.entityInstances»
			«instance.generate»
		«ENDFOR»
		'''
	}
	
	def dispatch CharSequence generate(EntityInstance instance) {
		val options = new ArrayList<CharSequence>
		for(o : instance.options) {
			val str = o.generate()
			if(str !== null) options.add(str)
		}
		
		if(options.size === 0) return '''''';
		
		'''
		#«instance.identifier» {
			«FOR o : options»
				«o»
			«ENDFOR»
		}
		'''
	}
	
	def dispatch CharSequence generate(Option o) {
		switch(o) {
			TextColorImpl: '''color: «o.color»;'''
			TextSizeImpl: '''font-size: «o.value + o.unit»;'''
			BackgroundColorImpl: '''«IF o.ref === null»background-color: «o.color»;«ELSE»background-color: «o.ref.value»;«ENDIF»'''
			DimOptionImpl: '''width: «o.width»;\nheight: «o.height»;'''
			default: null
		}
	}

	def generateDefaults() {
		'''
			#main{
				margin-top: 5px;
				margin-bottom: 5px;
				padding: 5px;
				width: fit-content;
			}
			.element {
				margin: 2px;
			}
			.vertical {
				width: 100%;
				justify-content: center;
			}
			.horizontal {
				width: 100%;
				justify-content: center;
			}
			.button {
				width: 100%;
				height: 100%;
			}
			.label {
				width: 100%;
				height: 100%;
				font-size: 22px;
			}
			.input {
				width: 100%;
				height: 100%;
			}
			.checkbox {
				width: 100%;
				height: 100%;
			}
			.text-area {
				width: 100%;
				height: 100%;
				margin: 2px;
			}
			.small {
				height: 40px;
			}
			.medium {
				height: 50px;
			}
			.large {
				height: 70px;
			}
		'''
	}

}
