package dk.sdu.mdsd.guilang.custom.impl

import dk.sdu.mdsd.guilang.guilang.Entity
import dk.sdu.mdsd.guilang.guilang.GuilangPackage
import dk.sdu.mdsd.guilang.guilang.Option
import dk.sdu.mdsd.guilang.guilang.impl.SpecificationImpl
import org.eclipse.emf.ecore.util.EObjectContainmentEList

class SpecificationImplCustom extends SpecificationImpl {
	
	new() {
		super()
	}
	
	new(Entity entity) {
		super()
		this.entity = entity
		this.options = new EObjectContainmentEList<Option>(typeof(Option), this, GuilangPackage.SPECIFICATION__OPTIONS);
	}
}