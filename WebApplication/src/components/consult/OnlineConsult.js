import React, { useEffect, useState } from 'react';
import { MDBContainer, MDBInputGroup,MDBInput, Container } from 'mdbreact';
import { connect } from 'react-redux';
import { doctorOnlineSubmit } from '../../actions/onlineConsult';
const OnlineConsult = ({ docDashFunc, doctorOnlineSubmit }) => {
  const [toggler, setToggler] = useState(false);
  const [medName, setMedName] = useState('');
  const [medTime, setMedTime] = useState('');
  const [medDuration, setMedDuration] = useState('');
  const [otherInfo, setOtherInfo] = useState('');
  const [doctorDiseaseName, setDoctorDiseaseName] = useState('');
  const [medicines, setMedicines] = useState([]);

  const handleConcat = (e) => {
    e.preventDefault();
    console.log(medName+medTime);
    var c = medName + ',' + medTime;
    console.log(c);
    setMedicines([...medicines, c]);
    
    setMedTime('');
    setMedName('');
  };
  useEffect(() => {
    console.log(medicines);
  },[medicines]);
  const { currentReport } = docDashFunc;
  const handleOnlineSubmit = (e) => {
    e.preventDefault();
    var updateReport = {
      medications: medicines,
      medicineDuration: medDuration,
      otherInfo,
    };
    if (doctorDiseaseName !== '') {
      updateReport = {
        ...updateReport,
        doctorDiseaseName,
      };
    }
    doctorOnlineSubmit({currentReport, updateReport});
  };
  const toggle = () => {
    if (toggler === true) setToggler(false);
    else setToggler(true);
  };
  return (
    <div>
      <Container style={{ maxWidth: 600, marginTop: 20 }}>
        <form>
          <div className='form-group row'>
            <div className='col-sm-9'>
              <div class='custom-control custom-checkbox'>
                <label class='custom-control-label' for='defaultChecked'>
                  Did the model predicted the disease correctly ?
                </label>
                <input
                  type='checkbox'
                  class='custom-control-input'
                  id='defaultChecked'
                  checked={true}
                  onClick={toggle}
                />
                {toggler && (
                  <MDBInput
                    outline
                    size='md'
                    label='Doctor Disease Name'
                    name=''
                    type='text'
                    value={doctorDiseaseName}
                    className='form-control'
                    onChange={(e) => setDoctorDiseaseName(e.target.value)}
                  />
                )}
              </div>
            </div>
            <div className='col-sm-9'>
              <h5>Medication</h5>
            </div>
            <div className='col s4'></div>
            <div className='col s4'>
              <button
                onClick={handleConcat}
                className='btn-floating btn-large waves-effect waves-light green'
              >
                <i class='fa fa-plus'>add</i>
              </button>
            </div>
          </div>
          <div className='form-group row'>
            <div className='col-sm-9'>
              <MDBInput
                outline
                size='md'
                label='Medicine Name'
                name='medName'
                type='text'
                value={medName}
                className='form-control'
                onChange={(e) => setMedName(e.target.value)}
              />
            </div>
          </div>
          <div className='form-group row'>
            <div className='col-sm-9'>
              <MDBInputGroup
                prepend='Medicine Time'
                inputs={
                  <select
                    className='form-control browser-default custom-select'
                    id='medTime'
                    value={medTime}
                    onChange={(e) => setMedTime(e.target.value)}
                  >
                    <option value='Morning'>Morning</option>
                    <option value='Afternoon'>Afternoon</option>
                    <option value='Evening'>Evening</option>
                    <option value='Night'>Night</option>
                    <option value='Afternoon+Night'>Afternoon + Night</option>
                  </select>
                }
              />
            </div>
          </div>
          <div className='form-group row'>
            <div className='col-sm-9'>
              <MDBInput
                outline
                size='md'
                label='Medicine Duration'
                name='medDuration'
                type='text'
                value={medDuration}
                className='form-control'
                onChange={(e) => setMedDuration(e.target.value)}
              />
            </div>
          </div>
          <div className='form-group row'>
            <div className='col-sm-9'>
              <MDBInput
                outline
                size='md'
                label='Other Information'
                name='otherInfo'
                type='text'
                value={otherInfo}
                className='form-control'
                onChange={(e) => setOtherInfo(e.target.value)}
              />
            </div>
          </div>
          <button onClick={handleOnlineSubmit}>Submit</button>
        </form>
      </Container>
    </div>
  );
};

const mapStateToProps = (state) => ({
  docDashFunc: state.docDashFunc,
});

const mapDispatchToProps = dispatch => ({
  doctorOnlineSubmit: (data) => dispatch(doctorOnlineSubmit(data))  
})
export default connect(mapStateToProps, mapDispatchToProps)(OnlineConsult);
