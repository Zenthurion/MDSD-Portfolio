package dk.sdu.mdsd.guilang

import dk.sdu.mdsd.guilang.guilang.Template
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import org.eclipse.xtext.naming.QualifiedName

class GuilangNameProvider extends DefaultDeclarativeQualifiedNameProvider {

	def protected QualifiedName qualifiedName(Template template){
		var name = template.eResource.URI.trimFileExtension.lastSegment + "." + template.name
		var qn = converter.toQualifiedName(name)
		println(qn) 
		return qn
	}
}