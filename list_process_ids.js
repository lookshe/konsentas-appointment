let authority_id;
let ret;

async function parseArguments() {
    const args = process.argv.slice(2);
    if (args.length != 1) {
        console.log('usage: node list_process_ids authority_id')
        throw new Error('wrong argument count');
    }
    authority_id = args[0];
}

async function main() {
    await parseArguments();
    ret = await fetch('https://stuttgart.konsentas.de/api/getOtaStartUp/?signupform_id=' + authority_id + '&userauth=&queryParameter%5Bsignup_new%5D=1').then(res => res.json());
    ret.data.op_conf.processes.forEach(p1 => {
      if (p1.hasOwnProperty('processes')) {
        p1.processes.forEach(p2 => {
          if (p2.options.length > 0) {
            p2.options.forEach(o => {
              console.log(p2.department_recno[0] + '_' + o.recno + ' -> ' + p1.department_name + ': ' + p2.process_name + '(' + o.option_name + ')')
            });
          } else {
              console.log(p2.department_recno[0] + '_' + p2.recno + ' -> ' + p1.department_name + ': ' + p2.process_name);
          }
        });
      } else {
          if (p1.options.length > 0) {
            p1.options.forEach(o => {
              console.log(p1.department_recno[0] + '_' + o.recno + ' -> ' + p1.process_name + '(' + o.option_name + ')');
            });
          } else {
              console.log(p1.department_recno[0] + '_' + p1.recno + ' -> ' + p1.process_name);
          }
      }
    });
}

main().catch(console.error);