package dk.sdu.mdsd.guilang

import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.Unit
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import org.eclipse.xtext.naming.QualifiedName

class GuilangNameProvider extends DefaultDeclarativeQualifiedNameProvider {

	def protected QualifiedName qualifiedName(Entity entity) {
		if(entity.name === null) return super.qualifiedName(entity)
		 
		var unit = EcoreUtil2.getContainerOfType(entity, Unit)
		
		return converter.toQualifiedName(unit.name + "." + entity.name)
	}
}