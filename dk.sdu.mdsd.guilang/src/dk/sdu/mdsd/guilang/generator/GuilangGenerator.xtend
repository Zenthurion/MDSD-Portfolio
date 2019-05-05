/*
 * generated by Xtext 2.16.0
 */
package dk.sdu.mdsd.guilang.generator

import com.google.inject.Inject
import dk.sdu.mdsd.guilang.custom.impl.SpecificationImplCustom
import dk.sdu.mdsd.guilang.generator.html.HTMLGenerator
import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.GuilangPackage
import dk.sdu.mdsd.guilang.guilang.Option
import dk.sdu.mdsd.guilang.guilang.Root
import dk.sdu.mdsd.guilang.guilang.Specification
import dk.sdu.mdsd.guilang.guilang.Unit
import dk.sdu.mdsd.guilang.guilang.UnitInstance
import dk.sdu.mdsd.guilang.guilang.UnitInstanceOption
import dk.sdu.mdsd.guilang.guilang.impl.SpecificationsImpl
import dk.sdu.mdsd.guilang.guilang.impl.TextValueImpl
import dk.sdu.mdsd.guilang.guilang.impl.UnitInstanceImpl
import dk.sdu.mdsd.guilang.guilang.util.GuilangAdapterFactory
import dk.sdu.mdsd.guilang.utils.GuilangModelUtils
import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.eclipse.xtext.resource.impl.ResourceDescriptionsProvider

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class GuilangGenerator extends AbstractGenerator {

	@Inject extension GuilangModelUtils
	@Inject extension GuilangAdapterFactory

	protected Resource resource
	protected IFileSystemAccess2 fsa
	protected IGeneratorContext context

	protected Root root
	protected Map<String, List<Option>> entityOptions
	protected String title

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		if(resource.allContents.filter(Root).next.main === null) return;

		initialise(resource, fsa, context)

		// printExportedObjects(resource)
		// resource.allContents.forEach[o | o.debugObjects]
		var ILanguageGenerator generator = new HTMLGenerator(resource, fsa, context)

		generator.generate()
	}

	@Inject ResourceDescriptionsProvider rdp

	def getResourceDescriptions(EObject o) {
		val index = rdp.getResourceDescriptions(o.eResource)
		index.getResourceDescription(o.eResource.URI)
	}

	def debugObjects(EObject o) {
		println("Exports: " + o.resourceDescriptions.exportedObjects)
		println("Exported Units: " + o.resourceDescriptions.getExportedObjectsByType(GuilangPackage.eINSTANCE.unit))
	}

	def initialise(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		this.resource = resource
		this.fsa = fsa
		this.context = context

		root = resource.allContents.filter(Root).next
		populateEntityOptions()
		title = getFileName(resource)

	}

	def populateEntityOptions() {
		entityOptions = new HashMap

		if (root.main.contents.specifications !== null) {
			for (spec : root.main.contents.specifications.list) {
				entityOptions.put(spec.entity.name, spec.options)
			}

		}
		for (template : root.templates) {
			for (spec : template.contents.specifications.list) {
				entityOptions.put(spec.entity.name, spec.options) // Likely candidate for ensuring  template field ids are concatenated with the template id  
			}
		}
	}

	def <T extends Option> T getOption(Entity entity, Class<T> type) {
		if(!entityOptions.containsKey(entity.name)) return null
		for (o : entityOptions.get(entity.name)) {
			if (type.isInstance(o))
				return o as T
		}
		return null
	}

	def <T extends Option> boolean hasOption(Entity entity, Class<T> type) {
		return getOption(entity, type) !== null
	}

	def getFileName(Resource resource) {
		var uri = resource.URI.toString
		return uri.substring(uri.lastIndexOf('/') + 1, uri.length - 4)
	}

	def getTextValue(Entity entity, Specification context) {
		if (context === null) 
			return ""
		
		var Specification specification
		if(context.entity instanceof UnitInstanceImpl) {
			specification = (context.options.findFirst[o|o instanceof UnitInstanceOption] as UnitInstanceOption).instanceSpecification
		} else {
			specification = context
		}
		
		if(specification.entity !== entity) return ""
		
		var option = specification.options.findFirst[o|o instanceof TextValueImpl] as TextValueImpl		
		
		return if(option === null) "" else (option as TextValueImpl).value
	}

	def getUnitInstanceCopy(UnitInstance unitInstance) {
		mergeOverridesWithTemplate(unitInstance, unitInstance.unit)
		return unitInstance
	}

	def mergeOverridesWithTemplate(UnitInstance unitInstance, Unit template) {
		
		
		var overrideInstanceSpecification = unitInstance.instanceOverrideSpecification

		if (overrideInstanceSpecification === null) {
			overrideInstanceSpecification = new SpecificationImplCustom(unitInstance)
			addSpecification(unitInstance, overrideInstanceSpecification)
			return;
		} 
		for (overrideOption : overrideInstanceSpecification.options) {
			if (overrideOption instanceof UnitInstanceOption) {
				val overrideSpecification = overrideOption.instanceSpecification
				val currentEntity = overrideSpecification.entity

				mergeSpecificationOptions(overrideOption.instanceSpecification, template.contents.specifications.
					list.findFirst[s|s.entity.name === currentEntity.name])

			// val matchInTemplate = unitInstance.unit.contents.specifications.list.findFirst[s|print("existing [" + s.entity.name + "], ") s.entity.name === currentEntity.name]
			// println()
			// if(matchInTemplate !== null){
			// println("Whoop!")
			// for(templateOption : matchInTemplate.options) {
			// val same = overrideOption.instanceSpecification.options.findFirst[instanceOption|instanceOption.class === templateOption.class]
			// if(same !== null) {
			// clone.unit.contents.specifications.list.remove(matchInTemplate)
			// clone.unit.contents.specifications.list.add(overrideOption.instanceSpecification)
			// } 
			// }
			// clone.unit.contents.specifications.list.remove(matchInTemplate)
			// clone.unit.contents.specifications.list.add(overrideOption.instanceSpecification)
			// } else {
			//
			// }
			}
		
		}
	}

	private def mergeSpecificationOptions(Specification overrideSpecification, Specification templateSpecification) {
		if(templateSpecification === null) return;

		for (to : templateSpecification.options) {
			val overrideOption = overrideSpecification.options.findFirst[oo|oo.class === to.class]
			if (overrideOption === null) {
				overrideSpecification.options.add(to)
				println(EcoreUtil2.getContainerOfType(overrideSpecification, Unit).name + " > " + overrideSpecification.entity.name + " > " + overrideOption.class.toString.substring(overrideOption.class.toString.lastIndexOf('.') + 1) + " is using template values")
			} else {
				println(EcoreUtil2.getContainerOfType(overrideSpecification, Unit).name + " > " + overrideSpecification.entity.name + " > " + overrideOption.class.toString.substring(overrideOption.class.toString.lastIndexOf('.') + 1) + " is overridden")
			}
		}
	}

	private def getInstanceOverrideSpecification(UnitInstance unitInstance) {
		// var instanceContainer = EcoreUtil2.getContainerOfType(unitInstance, Unit)
		// return EcoreUtil2.getAllContentsOfType(instanceContainer, Specification).findFirst[s|s.entity.name === unitInstance.name]
		return getSpecification(unitInstance)
	}
	
	def addSpecification(Entity entity, Specification specification) {
		if(entity != specification.entity) return;
		val instanceContainer = EcoreUtil2.getContainerOfType(entity, Unit)
		val specifications = EcoreUtil2.getAllContentsOfType(instanceContainer, SpecificationsImpl).findFirst[]
		specifications.list.add(specification)
	}

	def getSpecification(Entity entity) {
		var instanceContainer = EcoreUtil2.getContainerOfType(entity, Unit)
		var specification = EcoreUtil2.getAllContentsOfType(instanceContainer, Specification).findFirst [ s |
			s.entity.name === entity.name
		]
		return specification
	}
}
