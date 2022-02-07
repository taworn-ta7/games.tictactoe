import React from 'react'
import PropTypes from 'prop-types'
import classes from './PageHeader.module.css'

export default function PageHeader(props) {
    // rendering
    return (
        <div className={classes.header}>
            <div position="static">
                <div>
                    <span className={classes.text}>{props.title}</span>
                </div>
            </div>
        </div>
    )
}

PageHeader.propTypes = {
    title: PropTypes.string.isRequired,
    active: PropTypes.string.isRequired
}
