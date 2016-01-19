

import React from 'react';
import { Input } from 'react-bootstrap';
import CRUD from '../../commons/crud';
import WaitIcon from '../../components/wait-icon';
import Types from '../../forms/types';
import Form from '../../forms/form';

const crud = new CRUD('adminunit');

export default class AdminUnitInput extends React.Component {

	constructor(props) {
		super(props);
		this.onChange = this.onChange.bind(this);

		this.state = { };
	}


	componentWillMount() {
		// field is already initialized ?
		if (this.props.resources) {
			return this.setState({ list: this.props.resources });
		}

		// root was loaded ?
		if (!this.state.list) {
			const self = this;

			// request field initialization from server
			Form.initFields([{ id: 'v', type: 'adminUnit', value: this.props.value }])
				.then(res => self.setState({ list: res.v }));
		}
	}


	/**
	 * Called when the user changes the item selected
	 * @param  {SyntheticEvent} evt The event generated by React
	 */
	onChange(evt) {
		// get the reference of the select box
		const level = Number(evt.currentTarget.dataset.ref);
		const compRef = 'cb' + level;

		const list = this.state.list;

		// get the ID of the selected administrative unit
		const id = this.refs[compRef].getValue();
		const item = list[level - 1];

		// clear list of the next levels
		for (var i = level + 1; i <= 5; i++) {
			const aux = list[i];
			if (aux) {
				aux.list = null;
				aux.selected = null;
			}
		}

		// check if no item was selected
		if (id === '-') {
			item.selected = null;
			this.raiseChangeEvent();
			return;
		}

		// search for selected admin unit
		const admUnit = item.list.find(au => au.id === id);

		item.selected = admUnit.id;

		// is this the last select component ?
		if (level === 5 || !admUnit.unitsCount) {
			this.raiseChangeEvent();
			return;
		}

		// get the information about the next level
		const childItem = list[level];
		const self = this;

		item.fetching = true;
		// get children of the parent id
		crud.query({ parentId: id, profile: 'item' })
		.then(res => {
			childItem.list = res.list;
			delete item.fetching;
			self.forceUpdate();
		});

		this.raiseChangeEvent();
	}


	raiseChangeEvent() {
		// construct selected object
		const items = this.state.list.map(item =>
			item.selected ? { id: item.selected.id, name: item.selected.name } : null);

		const obj = {};
		let index = 0;
		items.forEach(item => {
			if (item) {
				obj['p' + index++] = item;
			}
		});

		if (this.props.onChange) {
			this.props.onChange({ value: obj, element: this.props.schema });
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
		const options = item.list ?
			item.list.map(opt => (
				<option key={opt.id} value={opt.id}>
					{opt.name}
				</option>
				)) : [];

		options.unshift(<option key="-" value="-" >{'-'}</option>);

		const ref = 'cb' + item.level;

		const self = this;

		const label = Form.labelRender(item.label, this.props.schema.required);

		const errors = item.level === 1 ? this.props.errors : null;

		return (
			<div key={item.level}>
				<Input ref={ref} data-ref={item.level} help={errors} bsStyle={errors ? 'error' : null}
					value={item.selected}
					type="select" label={label} onChange={self.onChange}>
					{options}
				</Input>
				{item.fetching && <WaitIcon type="field" />}
			</div>
			);
	}


	readOnlyRender(schema) {
		return (
			<Input
				label={schema.label}
				type="text"
				disabled
				value={Types.list.adminUnit.displayText(this.props.value)} />
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

AdminUnitInput.propTypes = {
	value: React.PropTypes.string,
	onChange: React.PropTypes.func,
	schema: React.PropTypes.object,
	errors: React.PropTypes.any,
	resources: React.PropTypes.array
};
