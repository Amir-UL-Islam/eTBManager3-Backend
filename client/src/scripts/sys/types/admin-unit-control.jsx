

import React from 'react';
import { Input } from 'react-bootstrap';
import CRUD from '../../commons/crud';
import { WaitIcon, SelectionBox } from '../../components';
import Form from '../../forms/form';
import FormUtils from '../../forms/form-utils';

const crud = new CRUD('adminunit');


/**
 * Field control to be used in forms to allow the user to select an administrative unit
 */
export default class AdminUnitControl extends React.Component {

	static typeName() {
		return 'adminUnit';
	}

	/**
	 * Display representation of the administrative unit
	 * @param  {[type]} value [description]
	 * @return {[type]}       [description]
	 */
	static displayText(value) {
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


	constructor(props) {
		super(props);
		this.onChange = this.onChange.bind(this);

		this.state = { };
	}


	componentWillMount() {
		const schema = this.props.schema || {};
		if (schema.readOnly) {
			return;
		}

		// field is already initialized ?
		if (this.props.resources) {
			this.setState({ list: this.props.resources });
			return;
		}

		// root was loaded ?
		if (!this.state.list) {
			const self = this;

			// request field initialization from server
//			FormUtils.initFields([{ id: 'v', type: 'adminUnit', value: this.props.value }])
			FormUtils.serverRequest({ cmd: 'adminUnit',  params: { value: this.props.value } })
				.then(res => self.setState({ list: res.v }));
		}
	}

	serverRequest(nextSchema, nextValue) {
		const res = nextSchema.resources;
		const val = nextValue ? nextValue.value : null;

		if (res) {
			if (!val) {
				return null;
			}

			const item = res.list[res.list.length - 1];
			const sel = item.options.find(opt => opt.id === item.id);
			if (sel) {
				return null;
			}
		}

		return {
			cmd: 'adminUnit',
			params: { value: this.props.value }
		};
	}


	/**
	 * Called when the user changes the item selected
	 * @param  {SyntheticEvent} evt The event generated by React
	 */
	onChange(item) {
		const self = this;

		return (evt, val) => {
			// get the reference of the select box
			const level = item.level;

			const list = self.state.list;

			// clear list of the next levels
			for (var i = item.level; i < 5; i++) {
				const aux = list[i];
				if (aux) {
					aux.list = null;
					aux.selected = null;
				}
			}

			// check if no item was selected
			if (!val) {
				item.selected = null;
				self.raiseChangeEvent(null);
				return;
			}

			item.selected = val.id;

			// check if must load other items
			if (level < 5 && val.unitsCount > 0) {
				// get the information about the next level
				const childItem = list[level];

				item.fetching = true;
				// get children of the parent id
				crud.query({ parentId: val.id, profile: 'item' })
				.then(res => {
					childItem.list = res.list;
					delete item.fetching;
					self.forceUpdate();
				});
			}

			self.raiseChangeEvent(item.selected);
		};
	}


	raiseChangeEvent(newvalue) {
		if (this.props.onChange) {
			this.props.onChange({ value: newvalue, schema: this.props.schema });
		}

		// force component to update its state
		this.forceUpdate();
	}

	/**
	 * Rend the selection box with administrative units
	 * @param  {[type]} item [description]
	 * @return {[type]}      [description]
	 */
	compRender(item) {
		const schema = this.props.schema || {};

		const ref = 'cb' + item.level;

		const self = this;

		const label = FormUtils.labelRender(item.label, schema.required);

		const errors = item.level === 1 ? this.props.errors : null;

		const val = item.selected ? item.list.find(doc => doc.id === item.selected) : null;

		return (
			<div key={item.level}>
				<SelectionBox ref={ref}
					help={errors} bsStyle={errors ? 'error' : null}
					value={val}
					optionDisplay="name"
					type="select" label={label} onChange={self.onChange(item)}
					noSelectionLabel="-"
					options={item.list} />
				{item.fetching && <WaitIcon type="field" />}
			</div>
			);
	}


	readOnlyRender(schema) {
		const value = this.props.value;
		const s = Form.types.adminUnit.controlClass().displayText(value);

		return (
			<Input
				label={schema.label}
				type="text"
				disabled
				value={s} />
			);
	}


	render() {
		const schema = this.props.schema || {};
		if (schema.readOnly) {
			return this.readOnlyRender(schema);
		}

		if (!this.state.list) {
			return null;
		}

		const self = this;
		const comps = this.state.list
			.filter(item => item.list)
			.map(item => self.compRender(item));

		return (
			<div>
				{comps}
			</div>
			);
	}
}


AdminUnitControl.propTypes = {
	value: React.PropTypes.any,
	onChange: React.PropTypes.func,
	schema: React.PropTypes.object,
	errors: React.PropTypes.any,
	resources: React.PropTypes.array
};
