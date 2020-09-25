import React,{ useState, useEffect, Fragment } from 'react';
import Questionaire from './Questionaire';
import { connect } from 'react-redux';
import { getDoctors, getDoctor,bookAppointment, generateReport } from '../../actions/doctorSearch';
import { clearCurrentReport } from '../../actions/dashboardFunc';
import { Button, Card } from 'react-bootstrap';

const DoctorConsult = ({history,match,dashFunc, predict,auth,getDoctor, doctorSearch, clearCurrentReport, bookAppointment, generateReport}) => {
    const [toggler,setToggler] = useState(true);
    
    useEffect(() => {
        const id = match.params.id;
        console.log(id);
        getDoctor(id);
    },[]);
    const { selectedDoctor,questions } = doctorSearch;

    

    const sendReport = (e) => {
        e.preventDefault();
        generateReport({ patientUid: auth.uid, predict, doctorSearch, selectedDoctor });
        clearCurrentReport();
        setToggler(false);
    }

    const {currentReport} = dashFunc;

    return (
        <div>
            {(toggler && selectedDoctor) && <div>
                <Card style={{ marginLeft: "auto", marginTop:"20px",marginRight:"auto",width: '30rem',borderRadius:"5px" }}>
                <Card.Img variant="top" src={selectedDoctor.profilePic} thumbnail style={{maxHeight:"300px",paddingRight:"10px", paddingLeft:"10px", marginTop:"20px", height:"300px", width:"100%", display:"block"}} />
                <Card.Body>
                  <Card.Title>{selectedDoctor.name}</Card.Title>
                  <Card.Text>
                    <p>{selectedDoctor.qualification}</p>
                    <p>{selectedDoctor.clinicAddress}</p>
                    <p>{selectedDoctor.experience}</p>
                  </Card.Text>
                  {toggler && <Button variant="orange text-white bold" onClick={sendReport}>Send Report</Button>}
                </Card.Body>
              </Card>
            </div>}
            {(!toggler && !currentReport) && <Fragment>
                <h5>Sent Report to Doctor. Wait for doctor confirmation.</h5>
                <button className="btn btn-warning" onClick={e => {
                    e.preventDefault();
                    history.push('/dashboard');
                }}>Go to dashboard</button>
                </Fragment>}
            
        </div>
    )
}
/*
<input type="date" value={selectDate} onChange={(e) => setSelectDate(e.target.value)} max={delayDate} min={curDate} />
                  {selectDate && <p>Slots:</p>}
                  {selectDate && slots.map(slot => 
                      <Button
                      disabled={lis.includes(slot.timeSlotStart)}
                      onClick={(e) => {
                      e.preventDefault();
                      book(slot.timeSlotStart);
                  }}>{slot.timeSlotStart}</Button>)}
*/
const mapStateToProps = (state) => ({
    doctorSearch: state.doctorSearch,
    auth: state.auth,
    predict: state.predict,
    dashFunc: state.dashFunc
});

const mapDispatchToProps = (dispatch) => ({
    getDoctor: (uid) => dispatch(getDoctor(uid)),
    bookAppointment: (data) => dispatch(bookAppointment(data)),
    generateReport: (data) => dispatch(generateReport(data)),
    clearCurrentReport: () => dispatch(clearCurrentReport())
});

export default connect(mapStateToProps,mapDispatchToProps)(DoctorConsult);
