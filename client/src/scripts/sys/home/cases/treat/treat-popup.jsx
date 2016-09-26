import React from 'react';
import { Overlay, Popover, ButtonToolbar, Button } from 'react-bootstrap';
import ReactDOM from 'react-dom';
import { durationDisplay } from '../../../../commons/utils';
import { server } from '../../../../commons/server';
import { app } from '../../../../core/app';


export default class TreatPopup extends React.Component {

    constructor(props) {
        super(props);
        this._getTarget = this._getTarget.bind(this);
        this.renderPresc = this.renderPresc.bind(this);
        this.onEditClick = this.onEditClick.bind(this);
    }


    _getTarget() {
        return ReactDOM.findDOMNode(this.props.target);
    }

    renderPeriod(period) {
        return (
            <div>
                <div className="clearfix">
                    <div className="pull-left">
                        {period.ini.format('L')}
                    </div>
                    <div className="pull-right">
                        {period.end.format('L')}
                    </div>
                </div>
                <div>
                    <b>{__('period.duration') + ': '}</b>
                    {durationDisplay(period.ini, period.end)}
                </div>
            </div>
        );
    }

    renderUnit(data) {
        return (
            <div style={{ minWidth: '230px' }}>
                {
                    this.renderPeriod(data)
                }
                <div className="mtop-2x">
                <ButtonToolbar>
                    <Button bsStyle="primary">{__('action.edit')}</Button>
                    <Button>{__('action.delete')}</Button>
                </ButtonToolbar>
                </div>
            </div>
            );
    }

    onEditClick() {
        if (this.props.onEdit) {
            this.props.onEdit(this.props.data.data);
        }
    }

    renderPresc(data) {
        const deleteMsg = () => app.messageDlg({
            title: __('cases.treat.prescription.delete'),
            message: __('form.confirm_remove'),
            style: 'warning',
            type: 'YesNo'
        }).then(res => {
            if (res === 'yes') {
                server.delete('/api/cases/case/treatment/prescription/delete/' + data.data.prescriptionId)
                    .then(() => {
                        app.dispatch('update-treatment');
                    });
            }
        });

        return (
            <div style={{ minWidth: '230px' }}>
                {
                    this.renderPeriod(data)
                }
                <div>
                    <b>{__('PrescribedMedicine.frequency') + ': '}</b>
                    {data.data.frequency + '/7'}
                </div>
                <div>
                    <b>{__('PrescribedMedicine.doseUnit') + ': '}</b>
                    {data.data.doseUnit}
                </div>
                <div className="mtop-2x">
                <ButtonToolbar>
                    <Button onClick={this.onEditClick} bsStyle="primary">{__('action.edit')}</Button>
                    <Button onClick={deleteMsg}>{__('action.delete')}</Button>
                </ButtonToolbar>
                </div>
            </div>
            );
    }

    render() {
        if (!this.props.target) {
            return null;
        }

        const data = this.props.data;

        const res = data.presc ?
        {
            title: data.presc.product.name,
            content: this.renderPresc(data)
        } :
        {
            title: data.text,
            content: this.renderUnit(data)
        };

        return (
            <Overlay
                rootClose
                onHide={this.props.onHide}
                show={this.props.show}
                target={this._getTarget}
                placement="bottom"
            >
                <Popover title={<b>{res.title}</b>} id="ppbar">
                    {res.content}
                </Popover>
            </Overlay>
            );

    }
}

TreatPopup.propTypes = {
    title: React.PropTypes.string,
    show: React.PropTypes.bool,
    target: React.PropTypes.any,
    data: React.PropTypes.object,
    onHide: React.PropTypes.func,
    onEdit: React.PropTypes.func
};
