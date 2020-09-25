const initalState = {
  appointments: null,
  reports: null,
  currentReport: {}
};

export default (state = initalState, action) => {
  switch (action.type) {
    case 'DOC_GET_APPOINTMENTS':
      return {
        ...state,
        appointments: action.payload,
      };
    case 'DOC_GET_REPORTS':
      return {
        ...state,
        reports: action.payload,
      };
    case 'SET_CURRENT_REPORT':
      return {
        ...state,
        currentReport: action.payload
      };
    case 'CLEAR_CURRENT_REPORT':
      return {
        ...state,
        currentReport:{}
      }
    case 'CHANGED_REPORT_STATUS':
      return {
        ...state,
        reports: state.reports.map(report => (report.id == action.payload.id) ? (report=action.payload):report)
      };
    case 'CLEAR_REPORT':
      return {
        ...state,
        currentReport: null
      }
    default:
      return state;
  }
};
