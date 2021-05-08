import React, { useState } from 'react';
import { setDoctorInfo, setDoctorUser } from '../../actions/info';
import { connect } from 'react-redux';
import { Container } from 'react-bootstrap';
import { MDBInput } from 'mdbreact';
const DoctorsInfo = ({ auth, history, info, setDoctorUser, setDoctorInfo }) => {
  const [clinicAddress, setAddress] = useState('');
  const [experience, setExperience] = useState('');
  const [qualification, setQualifications] = useState('');
  const [startTime, setStartTime] = useState('');
  const [endTime, setEndTime] = useState('');
  const [registrationNumber, setReg] = useState('');
  const [clinicSince, setCli] = useState('');
  const [appointments, setAppoint] = useState({});
  const [fees, setFees] = useState('');

  const states = {
    clinicAddress: '',
    experience: 'Otto',
    qualfication: '',
    startTime: '',
    endTime: '',
    onlineConsultingFee: '',
    inPersonConsultingFee: '',
  };

  const onSubmit = (e) => {
    e.preventDefault();
    e.target.className += ' was-validated';
    const doctor = {
      clinicAddress,
      experience,
      qualification,
      fees,
      startTime,
      endTime,
      registrationNumber,
      appointments,
    };
    setDoctorInfo(doctor);
    const data = {
      ...doctor,
      ...info.personalInfo,
      email: auth.user.email,
    };
    console.log(auth.uid);
    setDoctorUser({ data, uid: auth.uid });
    setAddress('');
    setExperience('');
    setQualifications('');
    setStartTime('');
    setEndTime('');
    setCli('');
    setReg('');
    //setProfilePicture('');
    history.push('/doctor/dashboard');
  };
  return (
    <div>
      <Container style={{ maxWidth: 600, marginTop: 20 }}>
        <form className='needs-validation' noValidate>
          <div class='form-group row'>
            <div className='col-sm-9'>
              <MDBInput
                outline
                size='sm'
                label='Clinic Address'
                name='address'
                type='text'
                value={clinicAddress}
                className='form-control'
                onChange={(e) => setAddress(e.target.value)}
              />
            </div>
          </div>
          <div class='form-group row'>
            <div className='col-sm-9'>
              <MDBInput
                outline
                size='sm'
                label='Experience'
                name='experience'
                type='text'
                value={experience}
                className='form-control'
                onChange={(e) => setExperience(e.target.value)}
                required
              />
            </div>
          </div>
          <div class='form-group row'>
            <div className='col-sm-9'>
              <MDBInput
                outline
                size='sm'
                label='Qualifications'
                name='qualfications'
                type='text'
                value={qualification}
                className='form-control'
                onChange={(e) => setQualifications(e.target.value)}
                required
              />
              <div className='invalid-feedback'>
                Please provide a valid qualfication.
              </div>
            </div>
          </div>
          <div class='form-group row'>
            <div className='col-sm-9'>
              <MDBInput
                outline
                size='sm'
                label='Online Consultation Fees'
                name='fees'
                type='text'
                value={fees}
                className='form-control'
                onChange={(e) => setFees(e.target.value)}
                required
              />
              <div className='invalid-feedback'>
                Please provide online consulation fees. 
              </div>
            </div>
          </div>
          <div class='form-group row'>
            <div className='col-sm-9'>
              <MDBInput
                outline
                size='sm'
                label='Clinic Opens At'
                name='Start Time'
                type='time'
                value={startTime}
                className='form-control'
                onChange={(e) => setStartTime(e.target.value)}
              />
            </div>
          </div>
          <div class='form-group row'>
            <div className='col-sm-9'>
              <MDBInput
                outline
                size='sm'
                label='Clinic Closes At'
                name='End Time'
                type='time'
                value={endTime}
                className='form-control'
                onChange={(e) => setEndTime(e.target.value)}
              />
            </div>
          </div>
        </form>
        <button onClick={onSubmit}>Submit</button>
      </Container>
    </div>
  );
};

const mapStateToProps = (state) => ({
  info: state.info,
  auth: state.auth,
});

const mapDispatchToProps = (dispatch) => ({
  setDoctorInfo: (patient) => dispatch(setDoctorInfo(patient)),
  setDoctorUser: (data) => dispatch(setDoctorUser(data)),
});

export default connect(mapStateToProps, mapDispatchToProps)(DoctorsInfo);
