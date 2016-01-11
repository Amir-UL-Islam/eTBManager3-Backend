/**
 * Complete component to offer CRUD capabilities to an entity. It displays the content in a table
 * and offers controls to create new items, delete and edit them
 */

import React from 'react';
import { Collapse, Alert, Button, ButtonToolbar } from 'react-bootstrap';
import FormDialog from '../../components/form-dialog';
import Form from '../../forms/form';
import { hasPerm } from '../session';
import { MessageDlg, CollapseCard, AsyncButton } from '../../components/index';
import CrudCard from './crud-card';


export default class CrudView extends React.Component {

	constructor(props) {
		super(props);
		// set the initial state
		this.state = { readOnly: !hasPerm(this.props.perm) };

		// function binding
		this.getCellSize = this.getCellSize.bind(this);
		this.cellRender = this.cellRender.bind(this);
		this.editClick = this.editClick.bind(this);
		this.deleteClick = this.deleteClick.bind(this);
		this.cardEventHandler = this.cardEventHandler.bind(this);
		this.deleteConfirm = this.deleteConfirm.bind(this);
	}

	componentWillMount() {
		this.refreshTable();
	}

	/**
	 * Called when the crud card wants to update its content
	 * @return {[type]} [description]
	 */
	refreshTable() {
		const self = this;

		return this.props.crud.query({ })
		.then(res => {
			// wrap itens inside a controller object
			const list = res.list.map(item => ({ data: item, state: 'ok' }));
			// generate new result
			const result = { count: res.count, list: list };
			// set state
			self.setState({ values: result });
			// return to the promise
			return result;
		});
	}


	cellRender(item, index) {
		// is in edit mode ?
		if (item.state === 'edit') {
			// display cell for editing
			return (
				<Collapse in transitionAppear>
					<div>
					<FormDialog formDef={this.props.editorDef}
						doc={item.context.doc}
						highlight
						onConfirm={item.context.saveForm}
						onCancel={item.context.cancelForm}
						/>
					</div>
				</Collapse>
				);
		}

		const content = this.props.onCellRender(item.data);

		// generate the hidden content
		const colRender = this.props.onCollapseCellRender;
		let colContent = colRender ? colRender(item.data) : null;
		colContent = (
				<div>
					{colContent}
					<ButtonToolbar className="mtop">
						<AsyncButton bsStyle="primary"
							fetching={item.state === 'fetching'}
							data-item={index}
							onClick={this.editClick}>{__('action.edit')}</AsyncButton>
						<Button bsStyle="link"
							onClick={this.deleteClick}
							data-item={index}>{__('action.delete')}</Button>
					</ButtonToolbar>
				</div>
			);

		// render the cell content
		return (
			<CollapseCard collapsable={colContent} padding="small">
				{content}
			</CollapseCard>
			);
	}


	/**
	 * Return the cell size (width) that will take the whole are if it is editing
	 * @param  {[type]} item [description]
	 * @return {[type]}      [description]
	 */
	getCellSize(item) {
		return item.state === 'edit' ? { xs: 12 } : this.props.cellSize;
	}


	cardEventHandler(evt) {
		if (evt.type === 'new') {
			this.openNewForm();
		}
	}


	createFormContext(doc, item) {
		const cntxt = {
			comp: this,
			doc: doc,
			item: item,
			errors: null
		};

		cntxt.saveForm = this.saveForm.bind(cntxt);
		cntxt.cancelForm = this.cancelForm.bind(cntxt);

		return cntxt;
	}


	openNewForm() {
		const doc = Form.newInstance(this.props.editorDef.layout);
		const formCont = this.createFormContext(doc);
		// set the state
		this.setState({
			newform: formCont,
			message: null });
	}

	/**
	 * Save content of the form. This function is executed in a exclusive context
	 * @return {Promise} Promise resolved when server return
	 */
	saveForm() {
		// get reference to the context ('this' is not the react component)
		const self = this;
		const crud = this.comp.props.crud;
		const promise = this.item ? crud.update(this.doc.id, this.doc) : crud.create(this.doc);

		return promise
			.then(() => {
				if (this.item) {
					this.item.state = 'ok';
				}

				self.comp.setState({
					values: null,
					newform: null,
					message: this.item ? __('default.entity_updated') : __('default.entity_created')
				});
				self.comp.refreshTable();
			});
	}

	/**
	 * Cancel form editor and hide form
	 * @return {[type]} [description]
	 */
	cancelForm() {
		const item = this.item;
		const comp = this.comp;

		if (item) {
			item.state = 'ok';
		}

		if (comp.state.newform) {
			comp.setState({ newform: null });
		}
		else {
			comp.forceUpdate();
		}
	}


	// formEventHandler(evt) {
	// 	const item = this.item;
	// 	const comp = this.self;

	// 	// user canceled the operation ?
	// 	if (evt.type === 'cancel') {
	// 		if (item) {
	// 			item.state = 'ok';
	// 		}
	// 		comp.setState({ editing: null });
	// 		return null;
	// 	}

	// 	// user confirmed the operation ?
	// 	if (evt.type === 'ok') {
	// 		// save the document
	// 		const crud = comp.props.crud;
	// 		const promise = item ? crud.update(evt.doc.id, evt.doc) : crud.create(evt.doc);

	// 		return promise
	// 			.then(() => {
	// 				if (item) {
	// 					item.state = 'ok';
	// 				}

	// 				comp.setState({
	// 					values: null,
	// 					editing: null,
	// 					message: item ? __('default.entity_updated') : __('default.entity_created')
	// 				});
	// 				comp.refreshTable();
	// 			});
	// 	}

	// 	return null;
	// }


	editClick(evt) {
		const item = this._cmdReference(evt);

		// show wait icon
		item.state = 'fetching';
		this.forceUpdate();

		// get data to edit from server
		const self = this;
		this.props.crud.get(item.data.id)
		.then(res => {
			const cntxt = this.createFormContext(res, item);

			item.state = 'edit';
			item.context = cntxt;
			self.forceUpdate();
		})
		.catch(() => {
			item.state = 'ok';
			self.forceUpdate();
		});
	}

	deleteClick(evt) {
		const item = this._cmdReference(evt);
		this.setState({
			showConfirm: true,
			item: item
		});
	}

	_cmdReference(evt) {
		evt.stopPropagation();
		// prevent panel to collapse
		evt.stopPropagation();

		// recover item
		const index = evt.currentTarget.dataset.item;
		return this.state.values.list[index];
	}


	deleteConfirm(action) {
		if (action === 'yes') {
			const self = this;

			this.props.crud
				.delete(this.state.item.data.id)
				.then(() => {
					self.setState({ message: __('default.entity_deleted') });
					self.refreshTable();
				});
		}
		this.setState({ showConfirm: false, doc: null, message: null });
	}

	/**
	 * Rend the new form
	 * @return {React.Component} The new form, or null if not in new form mode
	 */
	newFormRender() {
		// is it in editing mode ?
		const newform = this.state.newform;

		if (!newform) {
			return null;
		}

		return (
				<Collapse in transitionAppear>
					<div>
						<FormDialog formDef={this.props.editorDef}
							onConfirm={newform.saveForm}
							onCancel={newform.cancelForm}
							doc={newform.doc} />
					</div>
				</Collapse>
			);
	}


	/**
	 * Component render
	 * @return {[type]} [description]
	 */
	render() {
		if (!this.props) {
			return null;
		}

		// any message to be displayed
		const msg = this.state.message;


		return (
			<div>
				{
					msg && <Alert bsStyle="warning">{msg}</Alert>
				}
				{
					this.newFormRender()
				}
				<CrudCard title={this.props.title}
					onEvent={this.cardEventHandler}
					values={this.state.values}
					onCellSize={this.getCellSize}
					onCellRender={this.cellRender} />
				<MessageDlg show={this.state.showConfirm}
					onClose={this.deleteConfirm}
					title={__('action.delete')}
					message={__('form.confirm_remove')} style="warning" type="YesNo" />
			</div>
			);
	}
}

CrudView.propTypes = {
	title: React.PropTypes.string,
	editorDef: React.PropTypes.object,
	onCellRender: React.PropTypes.func,
	onCollapseCellRender: React.PropTypes.func,
	cellSize: React.PropTypes.object,
	perm: React.PropTypes.string,
	crud: React.PropTypes.object,
	search: React.PropTypes.bool,
	paging: React.PropTypes.bool
};

CrudView.defaultProps = {
	search: false,
	paging: false,
	cellSize: { md: 6 }
};

