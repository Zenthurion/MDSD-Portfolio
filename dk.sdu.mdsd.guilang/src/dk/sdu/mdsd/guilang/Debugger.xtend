package dk.sdu.mdsd.guilang

import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.naming.IQualifiedNameConverter
import org.eclipse.xtext.resource.IContainer
import org.eclipse.xtext.resource.IResourceDescriptions
import org.eclipse.xtext.resource.IResourceServiceProvider

class Debugger {
	@Inject IContainer.Manager manager
	@Inject IResourceServiceProvider.Registry rspr
	@Inject IQualifiedNameConverter converter

	def void printExportedObjects(Resource resource) {
		val resServiceProvider = rspr.getResourceServiceProvider(resource.URI)
		val manager = resServiceProvider.getResourceDescriptionManager()
		val description = manager.getResourceDescription(resource)
		for (eod : description.exportedObjects) {
			println(converter.toString(eod.qualifiedName))
		}
	}

	def void printVisibleResources(Resource resource, IResourceDescriptions index) {
		val descr = index.getResourceDescription(resource.URI)
		for (visibleContainer : manager.getVisibleContainers(descr, index)) {
			for (visibleResourceDesc : visibleContainer.resourceDescriptions) {
				println(visibleResourceDesc.URI)
			}
		}
	}
}
