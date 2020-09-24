import React, { useEffect } from 'react';
import { connect } from 'react-redux';
import Report from '../consult/Report';

const ViewReport = ({docDashFunc}) => {
    const { currentReport } = docDashFunc;
    
    return (
        <div>
            <Report report={currentReport} />
        </div>
    )
}

const mapStateToProps = state => ({
    docDashFunc: state.docDashFunc
})

export default connect(mapStateToProps)(ViewReport);