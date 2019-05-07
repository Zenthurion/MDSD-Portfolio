/*
 * generated by Xtext 2.16.0
 */
package dk.sdu.mdsd.guilang.validation

import com.google.inject.Inject
import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.GuilangPackage
import dk.sdu.mdsd.guilang.guilang.Main
import dk.sdu.mdsd.guilang.guilang.Specification
import dk.sdu.mdsd.guilang.utils.EntitySpecificationsProvider
import org.eclipse.xtext.validation.Check
import dk.sdu.mdsd.guilang.guilang.Template

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class GuilangValidator extends AbstractGuilangValidator {

	@Inject extension EntitySpecificationsProvider		
	
	public static val INVALID_NAME = 'invalidName'
	public static val INVALID_OPTION = 'invalidOption'

	@Check
	def checkValidOptions(Specification spec) {
		var correctOptions = getSpecifications(spec.entity.class)
		
		var int index = 0
		for (o : spec.options) {
			var flag = false;
			for (c : correctOptions) {
				if(c.option.isInstance(o)) {
					flag = true
				}
			}	
			if(!flag) {
				error('''"�o.class.shortName�" is not a valid option for an entity of type �spec.entity.class.shortName�''', GuilangPackage.Literals.SPECIFICATION__OPTIONS, index, INVALID_OPTION)
			}
			index++
		}
	} 

	@Check
	def checkMainNameStartWithCapital(Main main) {
		if (!Character.isUpperCase(main.name.charAt(0))) {
			warning("Main name should start with a capital letter", GuilangPackage.Literals.UNIT__NAME,
				INVALID_NAME)
		}
	}

	def private getShortName(Class<?> c) {
		var res = c.canonicalName
		return res.substring(res.lastIndexOf('.') + 1, res.length - 4)
	}

	@Check
	def checkMainNameMatchesFileName(Main main) {
		var name = main.eResource.URI.path
		name = name.subSequence(name.lastIndexOf("/") + 1, name.length - 4).toString
		if (!name.equalsIgnoreCase(main.name)) {
			warning("Main name should match the filename", GuilangPackage.Literals.UNIT__NAME,
				INVALID_NAME)
		}
	}


	@Check
	def checkTemplateNamesStartWithCapital(Template template) {
		if (!Character.isUpperCase(template.name.charAt(0))) {
			warning("Template names should start with a capital letter", GuilangPackage.Literals.UNIT__NAME,
				INVALID_NAME)
		}
	}

	@Check
	def checkEntityNamesStartWithLowerCase(Entity entity) {
		if (entity.name !== null && Character.isUpperCase(entity.name.charAt(0))) {
			warning("Entity names should start with a lowercase letter", GuilangPackage.Literals.ENTITY__NAME,
				INVALID_NAME)
		}
	}
}
