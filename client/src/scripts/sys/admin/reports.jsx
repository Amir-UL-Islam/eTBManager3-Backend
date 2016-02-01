
import React from 'react';
import PageContent from './page-content';

/**
 * Options of the left menu in the reports page
 * @type {Array}
 */
const menu = [
	{
		title: __('admin.websessions'),
		icon: 'users',
		perm: 'ONLINE',
		path: 'online'
	},
	{
		title: __('admin.reports.usersession'),
		icon: 'file-text-o',
		perm: 'USERSESREP',
		path: 'usersessions'
	},
	{
		title: 'Command history',
		icon: 'file-text-o',
		perm: 'CMDHISTORY',
		path: 'cmdhistory'
	},
	{
		title: 'Command statistics',
		icon: 'file-text-o',
		perm: 'CMDSTATISTICS',
		path: 'cmdstatistics'
	},
	{
		title: 'Error log report',
		icon: 'bug',
		perm: 'ERRORLOGREP',
		path: 'errorlogrep'
	}
];

/**
 * Reports page of the administration module
 */
export default class Reports extends React.Component {

	render() {
		return (
			<PageContent route={this.props.route}
				menu={menu}
				title={__('admin.reports')}
				path="/sys/admin/reps" />
			);
	}
}

Reports.propTypes = {
	route: React.PropTypes.object
};
