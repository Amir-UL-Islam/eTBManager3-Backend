/**
 * Base component to generate tree view in a vertical row. It basically
 * controls nodes and its state (collapsed and expanded), loading nodes in an
 * asynchronous way (using promises) and gives the parent
 * the role of rendering the row.
 */

import React from 'react';
import Fa from './fa';
import ReactCSSTransitionGroup from 'react-addons-css-transition-group';

import './tree-view.less';

export default class TreeView extends React.Component {

	constructor(props) {
		super(props);
		this.nodeClick = this.nodeClick.bind(this);
	}

	/**
	 * Load the nodes of the tree
	 * @param  {parent} parent The parent node to load items into
	 */
	loadNodes(parent) {
		const func = this.props.onGetNodes;

		if (!func) {
			return null;
		}

		const pitem = parent ? parent.item : undefined;
		let res = func(pitem);

		// is not a promise ?
		if (!res.then) {
			// force node resolution by promises
			res = Promise.resolve(res);
		}

		// create nodes wrapper when nodes are resolved
		const self = this;
		return res.then(items => {
			const nodes = self.createNodes(items);
			return nodes;
		});
	}

	/**
	 * Create nodes from the list of items to add in the tree
	 * @param  {[type]} items [description]
	 * @return {[type]}       [description]
	 */
	createNodes(items) {
		const funcInfo = this.props.checkLeaf;
		return items.map(item => {
			const leaf = funcInfo ? funcInfo(item) : false;
			return { item: item, state: 'collapsed', children: null, leaf: leaf };
		});
	}

	/**
	 * Create the React components of the nodes to be displayed in the tree
	 * @param  {[type]} nodes [description]
	 * @return {[type]}       [description]
	 */
	createNodesView() {
		const self = this;
		// get the item being expanded (for animation)
		const expitem = this.state && this.state.expitem;

		// recursive function to create the expanded tree in a list
		const mountList = function(nlist, level, parentkey) {
			let count = 0;
			const lst = [];
			nlist.forEach(node => {
				const key = (parentkey ? parentkey + '.' : '') + count;
				const row = self.createNodeRow(node, level, key);

				lst.push(row);
				if (node.state !== 'collapsed' && !node.leaf && node.children) {
					lst.push(mountList(node.children, level + 1, key, expitem === node));
				}
				count++;
			});

			// the children div key
			const divkey = (parentkey ? parentkey : '') + 'ch';

			// children are inside a div, in order to animate collapsing/expanding
			return (
				<ReactCSSTransitionGroup key={divkey + 'trans'} transitionName="node"
					transitionLeaveTimeout={250} transitionEnterTimeout={250} >
					{lst}
				</ReactCSSTransitionGroup>
				);
		};

		return mountList(this.getRoots(), 0, false);
	}

	/**
	 * Create node row containing the content of the node
	 * @param  {[type]} node  [description]
	 * @param  {[type]} level [description]
	 * @param  {[type]} key   [description]
	 * @return {[type]}       [description]
	 */
	createNodeRow(node, level, key) {
		const func = this.props.onRenderNode;

		const content = func ? func(node.item) : node.item;

		const expanded = node.state !== 'collapsed';

		return (
			<div key={key} style={{ marginLeft: (level * 16) + 'px' }}>
				<a onClick={this.nodeClick} data-item={key}>
					<Fa icon={expanded ? 'minus-square-o' : 'plus-square-o'} />
				</a>
				{content}
			</div>
			);
	}

	/**
	 * Called when user clicks on the plus/minus icon
	 * @param  {[type]} evt [description]
	 * @return {[type]}     [description]
	 */
	nodeClick(evt) {
		const key = evt.currentTarget.getAttribute('data-item');

		let lst = this.state.root;
		let node = null;

		key.split('.').forEach(index => {
			node = lst[Number(index)];
			lst = node.children;
		});

		if (node.state === 'collapsed') {
			this.expandNode(node);
		}
		else {
			this.collapseNode(node);
		}
	}

	/**
	 * Expand a given node
	 * @param  {[type]} node [description]
	 * @return {[type]}      [description]
	 */
	expandNode(node) {
		// children are not loaded ?
		if (!node.children) {
			node.state = 'expanding';

			// load the children
			const self = this;
			this.loadNodes(node)
				.then(res => {
					node.state = 'expanded';
					node.children = res;
					// force tree to show the new expanded node
					self.forceUpdate();
				});
		}
		else {
			node.state = 'expanded';
			// force tree to show the new expanded node
			this.forceUpdate();
		}
	}

	/**
	 * Collapse a given node and refresh the tree
	 * @param  {[type]} node [description]
	 * @return {[type]}      [description]
	 */
	collapseNode(node) {
		node.state = 'collapsed';
		this.forceUpdate();
	}

	/**
	 * Return the root list of nodes
	 * @return {array} Array of objects with information about the nodes
	 */
	getRoots() {
		if (this.props.root) {
			return this.props.root;
		}

		return this.state ? this.state.root : null;
	}

	/**
	 * Render the tree
	 * @return {[type]} [description]
	 */
	render() {
		const root = this.getRoots();

		if (!root) {
			const self = this;
			this.loadNodes()
				.then(res => self.setState({ root: res }));
			return null;
		}

		return <div className="tree-view">{this.createNodesView(root)}</div>;
	}
}

TreeView.propTypes = {
	// array containing the items to be displayed
	root: React.PropTypes.array,
	// called to load the nodes in the format function(item): promise
	onGetNodes: React.PropTypes.func,
	// called to render the div area that will host the node content
	// in the format function(item): string | React component
	onRenderNode: React.PropTypes.func,
	// opitional. Check if node has children or is a leaf node
	checkLeaf: React.PropTypes.func
};
