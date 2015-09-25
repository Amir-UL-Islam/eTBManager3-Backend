import React from 'react';
import { Grid, Row, Col, Input, Button, Fade, OverlayTrigger, Popover } from 'react-bootstrap';
import { navigator } from '../components/router.jsx';
import Title from '../components/title.jsx';


export default class InitOptions extends React.Component {
    constructor(props) {
        super(props);
        this.contClick = this.contClick.bind(this);
    }

    /**
     * Called when user clicks on the continue button
     */
    contClick() {
        navigator.goto('/init/newworkspace');
    }


    /**
     * Render the component
     */
    render() {
        let langs = this.props.appState.app.languages;
        let lg = window.app.getLang();

        return (
            <Fade in transitionAppear>
                <Grid>
                    <Row>
                        <Col md={6} mdOffset={3}>
                            <Title text={__('e-TB Manager initialization')}></Title>
                        </Col>
                    </Row>
                    <Row>
                        <Col md={6} mdOffset={3}>
                            <OverlayTrigger trigger="hover" placement="bottom"
                                            overlay={<Popover>It will start a fresh new instance of e-TB Manager from scratch</Popover>}>
                                <Input type="radio" checked label={__('Start e-TB Manager with a new workspace')}>
                                </Input>
                            </OverlayTrigger>
                            <OverlayTrigger trigger="hover" placement="bottom"
                                            overlay={<Popover>This instance will be in sync with another e-TB Manager</Popover>}>
                                <Input type="radio" label={__('I already have an e-TB Manager account')}>
                                </Input>
                            </OverlayTrigger>
                            <OverlayTrigger trigger="hover" placement="bottom"
                                            overlay={<Popover>Data will be imported from a previous version of e-TB Manager just this first time</Popover>}>
                                <Input type="radio" label={__('Import database from previous e-TB Manager version')}>
                                </Input>
                            </OverlayTrigger>
                        </Col>
                    </Row>
                    <Row>
                        <Col md={6} mdOffset={3}>
                            <div className="pull-right">
                                <Button bsStyle="primary" pullRight bsSize='large' onClick={this.contClick}>{__('Continue')}
                                </Button>
                            </div>
                        </Col>
                    </Row>
                </Grid>
            </Fade>
        );
    }
}