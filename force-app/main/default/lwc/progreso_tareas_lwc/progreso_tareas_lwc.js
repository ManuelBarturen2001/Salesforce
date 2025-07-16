import { LightningElement, api, wire  } from 'lwc';
import getTasksByContact from '@salesforce/apex/TareasCompletadasController.getCompletedTasks';

export default class Progreso_tareas_lwc extends LightningElement {
    @api recordId; // ID del contacto
    totalTasks = 0;
    completedTasks = 0;

    @wire(getTasksByContact, { contactId: '$recordId' })
    wiredTasks({ error, data }) {
        if (data) {
            this.totalTasks = data.length;
            this.completedTasks = data.filter(task => task.Status === 'Completed').length;
        } else if (error) {
            console.error('Error al obtener tareas:', error);
        }
    }

    get hasTasks() {
        return this.totalTasks > 0;
    }

    get completionPercent() {
        return this.totalTasks === 0 ? 0 : Math.round((this.completedTasks / this.totalTasks) * 100);
    }
}