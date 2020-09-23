import React,{ Fragment, useRef } from 'react';
import ReactPdf from 'react-to-pdf';
import { connect } from 'react-redux';

const Report = ({ doctorSearch }) => {
    const ref = useRef();
    const { report } = doctorSearch;
    return (
        <div>
            {report && <div ref={ref}>
                <h3 style={{color:"#ff9800", fontWeight:1000}}>DERMOSOLUTIONS</h3>
                <div>
                    <h5 style={{color: "ff9800",fontWeight:1000}}>Personal Information</h5>
                    <h6>Name: {report.patientName}</h6>
                    <h6>Gender: {report.gender}</h6>
                    <h6>Address: {report.city}</h6>
                </div>
                <div>
                    <h5 style={{color: "ff9800",fontWeight:1000}}>Contact Information</h5>
                    <h6>Email: {report.patientEmail}</h6>
                    <h6>Phone Number: {report.patientNumber}</h6>
                </div>
                <div>
                    <h5 style={{color: "ff9800",fontWeight:1000}}>Medical Information</h5>
                    <h6>Height: {report.patientHeight}</h6>
                    <h6>Weight: {report.patientWeight}</h6>
                    <h6>Blood Group: {report.bloodGroup}</h6>
                </div>
                <div>
                    <h5 style={{color: "ff9800",fontWeight:1000}}>Infection Details</h5>
                    <h6>Start Date: {report.duration}</h6>
                    <h6>Severity(out of 5): {report.severity}</h6>
                    <h6>Previous Medications: {report.prevMed}</h6>
                    <h6>Body Part Infected: {report.bodyPart}</h6>
                    <h6>Pain during : {report.timeOf}</h6>
                </div>
                <p></p>
                <p></p>
                <p></p>
                <div>
                    <h5 style={{color: "ff9800",fontWeight:1000}}>Model Predictions</h5>
                    <h6>Disease Name: {report.diseaseName}</h6>
                    <h6>Disease Image</h6>
                    <img src={report.diseaseUrl} height="40%" width="40%" />
                </div>
            </div>}
            {report && <ReactPdf targetRef={ref} filename={`report.${report.patientId}`}>
                {({ toPdf }) => <button onClick={toPdf}>Generate Pdf</button>}
            </ReactPdf>}
        </div>
    )
}


const mapStateToProps = state => ({
    doctorSearch: state.doctorSearch
})
export default connect(mapStateToProps)(Report);
