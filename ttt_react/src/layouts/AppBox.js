import React from 'react'
import PropTypes from 'prop-types'
import PageHeader from './PageHeader'
import PageFooter from './PageFooter'

export default class AppBox extends React.Component {

    constructor(props) {
        super(props)
        this.props = props
        this.state = {}
    }

    render() {
        let use = '24px'
        if (this.props.fit)
            use = 0

        return (
            <>
                <PageHeader title={this.props.title} active={this.props.active} />
                <div style={{ margin: use }}>
                    {this.props.children}
                </div>
                <PageFooter />
            </>
        )
    }

}

AppBox.propTypes = {
    children: PropTypes.element,
    title: PropTypes.string.isRequired,
    active: PropTypes.string.isRequired,
    fit: PropTypes.object
}
