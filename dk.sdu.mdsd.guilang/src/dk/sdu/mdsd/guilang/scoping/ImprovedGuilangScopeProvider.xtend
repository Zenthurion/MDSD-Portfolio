package dk.sdu.mdsd.guilang.scoping;

import com.google.inject.Inject
import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.GuilangPackage
import dk.sdu.mdsd.guilang.guilang.Layout
import dk.sdu.mdsd.guilang.guilang.Main
import dk.sdu.mdsd.guilang.guilang.Unit
import dk.sdu.mdsd.guilang.guilang.UnitInstance
import dk.sdu.mdsd.guilang.guilang.UnitInstanceOption
import dk.sdu.mdsd.guilang.guilang.impl.SpecificationImpl
import dk.sdu.mdsd.guilang.guilang.impl.SpecificationsImpl
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.resource.EObjectDescription
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.resource.impl.AliasedEObjectDescription
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.impl.SimpleScope

class ImprovedGuilangScopeProvider extends AbstractGuilangScopeProvider {
	@Inject extension IQualifiedNameProvider nameProvider
	override getScope(EObject context, EReference reference) {
		if(reference == GuilangPackage.Literals.SPECIFICATION__ENTITY) 
		{
			return scopeForSpecificationEntity(context, reference)
		} 
		else if(reference == GuilangPackage.Literals.UNIT_INSTANCE__UNIT) 
		{
			return super.getScope(context, reference) // Intentionally default
		}
		
		
		println("Using default scope > " + context + " <-> " + reference)
		return super.getScope(context, reference)
	}
	
	private def IScope scopeForSpecificationEntity(EObject context, EReference reference) {
		switch(context) {
			SpecificationsImpl: { // When at the root of specifications - Which entities are initially available
				val unit = EcoreUtil2.getContainerOfType(context, Unit)
				return unit.nestedEntities("").asScope // Consider trying to add the name of the unit as namespace
			}
			SpecificationImpl: {
				// Check for option?
				if(context.eContainer instanceof UnitInstanceOption) {
					
				}
				
				val unit = EcoreUtil2.getContainerOfType(context.eContainer, Unit)
				return unit.nestedEntities(unit.name).asScope // Consider trying to add the name of the unit as namespace
//				if(context.entity === null) {
//					return context.entity.nestedEntities("").asScope
//				}
			}
			UnitInstanceOption:println("thing")
		}
		return IScope.NULLSCOPE
	}
	
	private def IScope asScope(List<IEObjectDescription> descriptions) {
		return new SimpleScope(descriptions)
	}
	
	private def List<IEObjectDescription> nestedEntities(Unit unit, String namespace) {
		return unit.contents.layout.nestedEntities(namespace)
	}
	
	private def List<IEObjectDescription> nestedEntities(Entity entity, String namespace) {
		val list = new ArrayList<IEObjectDescription>
		if(entity.name !== null)
			list.add(entity.createDescription(namespace)) // No point in having scope for nameless entities. Just ensure that they get checked for nested entities
		
		if(entity instanceof UnitInstance) {
			list.addAll(entity.unit.contents.layout.nestedEntities(entity.qualifiedStringName(namespace)))
		} else if(entity instanceof Layout) {
			for(e : entity.entities)
				list.addAll(e.nestedEntities(namespace)) // Not current namespace, as I don't want entities with nested namespace for layout
		}
		
		return list
	}
	
	private def IEObjectDescription createDescription(Entity entity, String namespace) {
		if(entity.name === null) {
			println("Unable to create EObjectDescription for nameless entity")
			return null
		}
		val name = entity.qualifiedStringName(namespace)
		val qualified = QualifiedName.create(name)
		return new AliasedEObjectDescription(qualified, EObjectDescription.create(qualified, entity))
	}
	
	private def String qualifiedStringName(Entity entity, String namespace) {
		return if (entity.name === null) namespace else if(namespace == "") entity.name else namespace + "." + entity.name
	}
}
