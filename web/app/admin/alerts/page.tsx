"use client";

import { useEffect, useState } from "react";
import { Plus, Edit2, Trash2, FileText } from "lucide-react";
import { supabaseBrowser } from "@/lib/supabase-browser";
import AddAlertModal from "@/components/admin/alerts/AddAlertModal";
import EditAlertModal from "@/components/admin/alerts/EditAlertModal";

export default function AlertsPage() {
  const supabase = supabaseBrowser;
  const [alerts, setAlerts] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [showAddModal, setShowAddModal] = useState(false);
  const [editingAlert, setEditingAlert] = useState<any | null>(null);

  const fetchAlerts = async () => {
    setLoading(true);
    const { data, error } = await supabase
      .from("alerts")
      .select("*")
      .order("created_at", { ascending: false });

    if (!error && data) setAlerts(data);
    setLoading(false);
  };

  useEffect(() => {
    fetchAlerts();
  }, []);

  const handleDelete = async (id: string) => {
    if (!confirm("Are you sure you want to delete this alert?")) return;

    try {
      const { error } = await supabase.from("alerts").delete().eq("id", id);
      if (error) throw error;
      alert("🗑️ Alert deleted successfully!");
      fetchAlerts();
    } catch (error: any) {
      console.error("Delete failed:", error.message);
      alert("❌ Failed to delete alert.");
    }
  };

  if (loading) {
    return (
      <div className="p-8 text-center text-gray-600">
        Loading alerts...
      </div>
    );
  }

  return (
    <div className="p-8">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-3xl font-bold text-[#8B1538]">
          Alerts & Circulars
        </h1>
        <button
          onClick={() => setShowAddModal(true)}
          className="bg-[#8B1538] text-white px-4 py-2 rounded-lg flex items-center gap-2 hover:bg-[#6B0F28] transition"
        >
          <Plus className="w-4 h-4" /> New Alert
        </button>
      </div>

      {alerts.length === 0 ? (
        <p className="text-gray-500">No alerts or circulars yet.</p>
      ) : (
        <div className="space-y-4">
          {alerts.map((alert) => (
            <div
              key={alert.id}
              className="bg-white border border-[#8B1538]/20 rounded-xl p-5 shadow-sm relative"
            >
              <div className="flex justify-between items-start">
                <div>
                  <h2 className="text-xl font-semibold text-[#8B1538]">
                    {alert.title}
                  </h2>
                  <p className="text-gray-700">{alert.description}</p>

                  <div className="text-sm text-gray-500 mt-2">
                    Type:{" "}
                    <span className="font-semibold text-[#8B1538]">
                      {alert.type}
                    </span>{" "}
                    • {new Date(alert.created_at).toLocaleString()}
                    {alert.type === "Event" && alert.start_date && (
                      <span>
                        {" "}
                        • {alert.start_date} → {alert.end_date}
                      </span>
                    )}
                  </div>

                  {alert.file_url && (
                    <a
                      href={alert.file_url}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex items-center gap-2 text-[#8B1538] hover:underline mt-2 text-sm"
                    >
                      <FileText className="w-4 h-4" /> View Attachment
                    </a>
                  )}

                  <p className="text-xs text-gray-400 mt-2">
                    Posted by: Campus CSE Office Admin
                  </p>
                </div>

                <div className="flex gap-3">
                  <button
                    onClick={() => setEditingAlert(alert)}
                    className="text-[#8B1538] hover:text-[#6B0F28]"
                    title="Edit"
                  >
                    <Edit2 className="w-5 h-5" />
                  </button>

                  <button
                    onClick={() => handleDelete(alert.id)}
                    className="text-red-600 hover:text-red-800"
                    title="Delete"
                  >
                    <Trash2 className="w-5 h-5" />
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Modals */}
      {showAddModal && (
        <AddAlertModal
          onClose={() => setShowAddModal(false)}
          refresh={fetchAlerts}
        />
      )}
      {editingAlert && (
        <EditAlertModal
          alertData={editingAlert}
          onClose={() => setEditingAlert(null)}
          refresh={fetchAlerts}
        />
      )}
    </div>
  );
}
