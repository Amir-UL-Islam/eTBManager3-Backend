
import Types from '../../forms/types';
import UnitInput from './unit-input';

/**
 * Type handle for administrative unit series
 */
export default class UnitType extends Types.BaseClass {

	requireServerInit(schema) {
		return !schema.readOnly;
	}

	/**
	 * Display representation of the administrative unit
	 * @param  {[type]} value [description]
	 * @return {[type]}       [description]
	 */
	displayText(value) {
		if (!value) {
			return '';
		}

		const vals = [];
		let index = 4;
		while (index >= 0) {
			const p = value['p' + index];
			if (p) {
				vals.push(p.name);
			}
			index--;
		}

		return vals.join(', ');
	}

	toServer(value) {
		return value && value.p0 ? value.p0.id : null;
	}

	formComponent() {
		return UnitInput;
	}
}
