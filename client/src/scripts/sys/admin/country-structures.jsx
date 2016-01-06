
import React from 'react';
import CrudView from './crud-view';
import CRUD from '../../commons/crud';

const crud = new CRUD('countrystructure');

// definition of the table that will display the list of sources
// const tableDef = {
// 	title: __('admin.auorg'),
// 	columns: [
// 		{
// 			title: __('form.name'),
// 			property: 'name'
// 		},
// 		{
// 			title: __('form.level'),
// 			property: 'level'
// 		}
// 	]
// };

// definition of the form fields to edit substances
const editorDef = {
	layout: [
		{
			property: 'name',
			required: true,
			type: 'string',
			max: 100,
			label: __('form.name'),
			size: { sm: 6 }
		},
		{
			property: 'level',
			required: true,
			type: 'int',
			label: __('form.level'),
			options: { from: 1, to: 5 },
			size: { sm: 3 }
		}
	],
	title: doc => doc && doc.id ? __('admin.auorg.edt') : __('admin.auorg.new')
};

/**
 * The page controller of the public module
 */
export default class CountryStructures extends React.Component {

	cellRender(item) {
		return (
			<div>
				<div className="pull-right">{__('form.level') + ' ' + item.level}</div>
				{item.name}
			</div>
			);
	}

	render() {
		return (
			<CrudView crud={crud}
				onCellRender={this.cellRender}
				editorDef={editorDef}
				cellSize={{ md: 12 }}
				perm="ADMINUNIT_ED" />
			);
	}
}

CountryStructures.propTypes = {
	route: React.PropTypes.object
};
