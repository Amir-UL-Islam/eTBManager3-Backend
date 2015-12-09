
import React from 'react';
import { Table } from 'react-bootstrap';
import { Card, WaitIcon } from '../../components/index';
import CRUD from '../../commons/crud';

const crud = new CRUD('adminunit');

/**
 * The page controller of the public module
 */
export class AdmUnits extends React.Component {

	render() {
		const res = this.state ? this.state.result : null;

		let tbl;

		if (!res) {
			const self = this;
			crud.query({ rootUnits: true })
			.then(result => self.setState({ result: result }));

			tbl = <tr><td><WaitIcon /></td></tr>;
		}
		else {
			tbl = res.list.map(item => (
					<tr key={item.id}>
						<td>{item.name}</td>
					</tr>
				));
		}

		return (
			<Card title={__('admin.adminunits')}>
				<Table responsive>
					<thead>
						<tr>
							<th>
								{'Name'}
							</th>
						</tr>
					</thead>
					<tbody>
						{tbl}
					</tbody>
				</Table>
			</Card>
			);
	}
}