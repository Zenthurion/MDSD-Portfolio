package dk.sdu.mdsd.guilang

import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.Unit
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import org.eclipse.xtext.naming.QualifiedName

class GuilangNameProvider extends DefaultDeclarativeQualifiedNameProvider {

//	def protected QualifiedName qualifiedName(Entity entity) {
//		return converter.toQualifiedName(entity.name)
//	}

	def protected QualifiedName qualifiedName(Entity entity) {
		if(entity.name === null) return null // Consider ""
		
		var unit = EcoreUtil2.getContainerOfType(entity, Unit)
		
		
		return converter.toQualifiedName(unit.name + "." + entity.name)
	}

//	def protected QualifiedName qualifiedName(Entity entity) {
//		if(entity.name === null) return null
//		var name = entity.name
//		
//		var container = EcoreUtil2.getContainerOfType(entity.eContainer, UnitInstance)
//		var feature = entity.eContainingFeature
//		var containment = entity.eContainmentFeature
//		while(container !== null) {
//			name = container.name + "." + name
//			container = EcoreUtil2.getContainerOfType(container.eContainer, UnitInstance)
//		}
//		val qn = converter.toQualifiedName(name)
//		println(entity.name + ": " + qn)
//		return qn
//	}
//	def protected QualifiedName qualifiedName(Template template){
//		var name = template.eResource.URI.trimFileExtension.lastSegment + "." + template.name
//		var qn = converter.toQualifiedName(name)
//		println(qn) 
//		return qn
//	}
}